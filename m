Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED413A5FAC
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 12:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhFNKH4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 06:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232691AbhFNKHz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 06:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623665153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tXws9JYBMj0JewW/qIDYFM6K9WZgnfl946vRkJEYDfQ=;
        b=fNNN1nLsoCp9fE//dAz7frkjVYUzT6xR8aqJGrspqMKDxRLe/pYV1WZy2S9CjUs7MGGvVu
        Vje+tv1EXayWdTC+aH8EPCNC4uEcFA5ZJGeYPazAcEa3///04HrxIIXWmiQJK3JrAUoMNJ
        T/3uQqQTSGcFkRfxXPbMmCtS6HmzQyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-ANi7JeVgO0aGseLlw9bxzw-1; Mon, 14 Jun 2021 06:05:49 -0400
X-MC-Unique: ANi7JeVgO0aGseLlw9bxzw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B802C1084F57;
        Mon, 14 Jun 2021 10:04:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E8BD70589;
        Mon, 14 Jun 2021 10:04:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210613233345.113565-1-jlayton@kernel.org>
References: <20210613233345.113565-1-jlayton@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, linux-cachefs@redhat.com, idryomov@gmail.com,
        willy@infradead.org, pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when writing beyond EOF
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <338980.1623665093.1@warthog.procyon.org.uk>
Date:   Mon, 14 Jun 2021 11:04:53 +0100
Message-ID: <338981.1623665093@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> wrote:

> +/**
> + * prep_noread_page - prep a page for writing without reading first

It's a static function, so I'm not sure it needs the kernel doc marker.

It also needs prefixing with "netfs_".

> +	/* pos beyond last page in the file */
> +	if (index > ((i_size - 1) / thp_size(page)))
> +		goto zero_out;

thp_size() is not a constant, so this gets you a DIV instruction.

Why not:

	if (page_offset(page) >= i_size)

or maybe:

	if (pos - offset >= i_size)

> +	zero_user_segments(page, 0, offset, offset + len, thp_size(page));

If you're going to leave a hole in the file, this will break afs, so this
patch needs to deal with that too (basically if copied < len, then the
remainder needs clearing, give or take len being trimmed to the end of the
page).  I can look at adding that.

Matthew Wilcox <willy@infradead.org> wrote:

> > +	size_t offset = offset_in_page(pos);
> 
> offset_in_thp(page, pos);

I can make this change too.

(btw, can offset_in_thp() have it's second arg renamed to 'pos', not just 'p'?
 'p' is normally used to indicate a pointer of some sort).

