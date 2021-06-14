Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B70A3A5FE1
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 12:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhFNKVy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 06:21:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232691AbhFNKVv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 06:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623665989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MEyC9MDHaIucm/UvQohkBX18m+moRkatl/6dX4zAUKI=;
        b=GgpzJNkUUye+FXd1Q6p5VH+UCazNpMyvQjgUN0XUf4veEuJw/32YKNAtgnY4jcvlzS60U7
        Yq6h+gZpWSsLocfMs3EyIo6DfbusA3j5Lb6+2NaKbyI304/9hoXRMMJSqBQymRZ5d3n4Ac
        POdMkKemoCE1sXbJWL7YS6CLh+TymPg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-n-cfUoa-OOyfxV78AHBqUw-1; Mon, 14 Jun 2021 06:19:45 -0400
X-MC-Unique: n-cfUoa-OOyfxV78AHBqUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C93680EDAD;
        Mon, 14 Jun 2021 10:19:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2B5619C45;
        Mon, 14 Jun 2021 10:19:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <338981.1623665093@warthog.procyon.org.uk>
References: <338981.1623665093@warthog.procyon.org.uk> <20210613233345.113565-1-jlayton@kernel.org>
Cc:     dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
        linux-cachefs@redhat.com, idryomov@gmail.com, willy@infradead.org,
        pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when writing beyond EOF
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <340610.1623665978.1@warthog.procyon.org.uk>
Date:   Mon, 14 Jun 2021 11:19:38 +0100
Message-ID: <340611.1623665978@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > +	zero_user_segments(page, 0, offset, offset + len, thp_size(page));
> 
> If you're going to leave a hole in the file, this will break afs, so this
> patch needs to deal with that too (basically if copied < len, then the
> remainder needs clearing, give or take len being trimmed to the end of the
> page).  I can look at adding that.

Clearing or reading.

David

