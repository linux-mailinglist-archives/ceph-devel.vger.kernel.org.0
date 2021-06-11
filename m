Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFA23A4ABF
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 23:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhFKVtV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 17:49:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229777AbhFKVtV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 17:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623448042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bNJkmVC8OQ2CxelJ4M8HaiLjW6KQZdwB2Fx4bQLR/HI=;
        b=QGsKP6IQdeUxq50s6gGYWOo1EH1lTsP35x0lf7UrK9CtFfdsPswh0Ea7vVSZso+2UCw+xZ
        e7R/1cM09yqAtkugUYY2mCUrZLDgy93ADi/DkbuIg9OiBlXMtSseHh5mCAN3x7CPUQEG+c
        mQIaekbjJIUPm60xX+wOVTyhjy1lYT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-eU5odBXRNAS64v3RnQoJfA-1; Fri, 11 Jun 2021 17:47:21 -0400
X-MC-Unique: eU5odBXRNAS64v3RnQoJfA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8D49803621;
        Fri, 11 Jun 2021 21:47:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BFEF5D9D7;
        Fri, 11 Jun 2021 21:47:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <YMOj1rjCOb4fQo5Y@casper.infradead.org>
References: <YMOj1rjCOb4fQo5Y@casper.infradead.org> <YMN/PfW2t8e5M58m@casper.infradead.org> <a24c3c070c9fc3529a51f00f9ccc3d0abdd0b821.camel@kernel.org> <20200916173854.330265-1-jlayton@kernel.org> <20200916173854.330265-6-jlayton@kernel.org> <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org> <m2h7i45vzl.fsf@discipline.rit.edu> <66264.1623424309@warthog.procyon.org.uk> <68477.1623425725@warthog.procyon.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
        Andrew W Elble <aweits@rit.edu>, ceph-devel@vger.kernel.org,
        pfmeec@rit.edu, linux-cachefs@redhat.com
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into ceph_write_begin
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <97001.1623448034.1@warthog.procyon.org.uk>
Date:   Fri, 11 Jun 2021 22:47:14 +0100
Message-ID: <97002.1623448034@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> Anyway, looking at netfs_write_begin(), it's wrong too, in a bunch of
> ways.  You don't need to zero out the part of the page you're going to
> copy into.

Zeroing it out isn't 'wrong', per se, just inefficient.  Fixing that needs the
filesystem to deal with it if the copy fails.

> And the condition is overly complicated which makes it
> hard to know what's going on.  Setting aside the is_cache_enabled part,
> I think you want:
> 
> 	if (offset == 0 && len >= thp_size(page))
> 		goto have_page_no_wait;
> 	if (page_offset(page) >= size) {
> 		zero_user_segments(page, 0, offset,
> 				   offset + len, thp_size(page));

There's a third case too: where the write starts at the beginning of the page
and goes to/straddles the EOF - but doesn't continue to the end of the page.

You also didn't set PG_uptodate - presumably deliberately because there's a
hole potentially containing random rubbish in the middle.

> 		goto have_page_no_wait;
> 	}
> 	... read the interesting chunks of page ...

David

