Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D04C3A4587
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 17:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhFKPhc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 11:37:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231887AbhFKPhc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 11:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623425733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3K2QbnSuP6eCRtdZbHlf4KY6YGcbnWxdsJ5goj82Uwk=;
        b=Y2q64b0luDj1Kq74lA2bGmNlSozF4mdir//b5PMMySfG/X1eOgvDkCIWHf5kbnh99I21c+
        Pu1KB91iuCiPmvrNBh4roRdhv76I4P2uEQSuc0/zAC77Zx6yFsLjeLHNa4noKBUV6ath2h
        baOwSX1KpLPQsXj/c6BgorUYd2q2Gd8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-SMxUOtYzP8-aKnG8cnK8eA-1; Fri, 11 Jun 2021 11:35:32 -0400
X-MC-Unique: SMxUOtYzP8-aKnG8cnK8eA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F4DE100D926;
        Fri, 11 Jun 2021 15:35:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D417B138EA;
        Fri, 11 Jun 2021 15:35:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <YMN/PfW2t8e5M58m@casper.infradead.org>
References: <YMN/PfW2t8e5M58m@casper.infradead.org> <a24c3c070c9fc3529a51f00f9ccc3d0abdd0b821.camel@kernel.org> <20200916173854.330265-1-jlayton@kernel.org> <20200916173854.330265-6-jlayton@kernel.org> <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org> <m2h7i45vzl.fsf@discipline.rit.edu> <66264.1623424309@warthog.procyon.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
        Andrew W Elble <aweits@rit.edu>, ceph-devel@vger.kernel.org,
        pfmeec@rit.edu, linux-cachefs@redhat.com
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into ceph_write_begin
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <68476.1623425725.1@warthog.procyon.org.uk>
Date:   Fri, 11 Jun 2021 16:35:25 +0100
Message-ID: <68477.1623425725@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> Yes.  I do that kind of thing in iomap.  What you're doing there looks
> a bit like offset_in_folio(), but I don't understand the problem with
> just checking pos against i_size directly.

pos can be in the middle of a page.  If i_size is at, say, the same point in
the middle of that page and the page isn't currently in the cache, then we'll
just clear the entire page and not read the bottom part of it (ie. the bit
prior to the EOF).

It's odd, though, that xfstests doesn't catch this.

David

