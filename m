Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C2224047C
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Aug 2020 12:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgHJKJY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Aug 2020 06:09:24 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59640 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726396AbgHJKJY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Aug 2020 06:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597054163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=efUJGn0npNqkJA1wcUT/ke4XF8YVFPXXbP9JUj4a+rY=;
        b=A+/3cL3bTcarkJ3HlMC5mRzpvF657xsaixT/MAZGoddAA6QDIPFJiCObNNpV7QZRmANVoP
        Rl992wzX/M/IcgNlrXCr1FJVgMG7iq8pGmEi2lA3aEwVZe9q/30bVBPA3FUKyfAUtsQsjJ
        jzggBQJRu9zSQzxIo7KkDJW6aVup/7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-80r1_EkVOJGE5ZSJsuWU0A-1; Mon, 10 Aug 2020 06:09:21 -0400
X-MC-Unique: 80r1_EkVOJGE5ZSJsuWU0A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83D8BE91B;
        Mon, 10 Aug 2020 10:09:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-69.rdu2.redhat.com [10.10.113.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98F505F1EA;
        Mon, 10 Aug 2020 10:09:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CALF+zOnQ6diJv4bMbf-HSYmHusT_iE1dAqp-j_kjuqyLqfp-nw@mail.gmail.com>
References: <CALF+zOnQ6diJv4bMbf-HSYmHusT_iE1dAqp-j_kjuqyLqfp-nw@mail.gmail.com> <20200731130421.127022-1-jlayton@kernel.org> <20200731130421.127022-10-jlayton@kernel.org>
To:     David Wysochanski <dwysocha@redhat.com>
Cc:     dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org, linux-cachefs@redhat.com,
        idryomov@gmail.com
Subject: Re: [Linux-cachefs] [RFC PATCH v2 09/11] ceph: convert readpages to fscache_read_helper
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <526037.1597054155.1@warthog.procyon.org.uk>
Date:   Mon, 10 Aug 2020 11:09:15 +0100
Message-ID: <526038.1597054155@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

David Wysochanski <dwysocha@redhat.com> wrote:

> Looks like fscache_shape_request() overrides any 'max_pages' value (actually
> it is cachefiles_shape_request) , so it's unclear why the netfs would pass
> in a 'max_pages' if it is not honored - seems like a bug maybe or it's not
> obvious

I think the problem is that cachefiles_shape_request() is applying the limit
too early.  It's using it to cut down the number of pages in the original
request (only applicable to readpages), but then the shaping to fit cache
granules can exceed that, so it needs to be applied later also.

Does the attached patch help?

David
---
diff --git a/fs/cachefiles/content-map.c b/fs/cachefiles/content-map.c
index 2bfba2e41c39..ce05cf1d9a6e 100644
--- a/fs/cachefiles/content-map.c
+++ b/fs/cachefiles/content-map.c
@@ -134,7 +134,8 @@ void cachefiles_shape_request(struct fscache_object *obj,
 	_enter("{%lx,%lx,%x},%llx,%d",
 	       start, end, max_pages, i_size, shape->for_write);
 
-	if (start >= CACHEFILES_SIZE_LIMIT / PAGE_SIZE) {
+	if (start >= CACHEFILES_SIZE_LIMIT / PAGE_SIZE ||
+	    max_pages < CACHEFILES_GRAN_PAGES) {
 		shape->to_be_done = FSCACHE_READ_FROM_SERVER;
 		return;
 	}
@@ -144,10 +145,6 @@ void cachefiles_shape_request(struct fscache_object *obj,
 	if (shape->i_size > CACHEFILES_SIZE_LIMIT)
 		i_size = CACHEFILES_SIZE_LIMIT;
 
-	max_pages = round_down(max_pages, CACHEFILES_GRAN_PAGES);
-	if (end - start > max_pages)
-		end = start + max_pages;
-
 	granule = start / CACHEFILES_GRAN_PAGES;
 	if (granule / 8 >= object->content_map_size) {
 		cachefiles_expand_content_map(object, i_size);
@@ -185,6 +182,10 @@ void cachefiles_shape_request(struct fscache_object *obj,
 		start = round_down(start, CACHEFILES_GRAN_PAGES);
 		end   = round_up(end, CACHEFILES_GRAN_PAGES);
 
+		/* Trim to the maximum size the netfs supports */
+		if (end - start > max_pages)
+			end = round_down(start + max_pages, CACHEFILES_GRAN_PAGES);
+
 		/* But trim to the end of the file and the starting page */
 		eof = (i_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		if (eof <= shape->proposed_start)

