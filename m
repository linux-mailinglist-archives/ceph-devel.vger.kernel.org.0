Return-Path: <ceph-devel+bounces-1131-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 600118B8EAE
	for <lists+ceph-devel@lfdr.de>; Wed,  1 May 2024 19:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00A191F25F89
	for <lists+ceph-devel@lfdr.de>; Wed,  1 May 2024 17:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 868E417BA3;
	Wed,  1 May 2024 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MSRxgjH8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E0A14267
	for <ceph-devel@vger.kernel.org>; Wed,  1 May 2024 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714582873; cv=none; b=f5sdZMtKeHgbOeVH5+kVuTrHSIzTlqA53x4vWs5sbvLs9z0N+TP33Lo0iHGfii+m9fQTvQ8EvkdBV6oi7abNmbvA8QzaLwfSyOmAKv7qo8ph7ZumRmOijT1OLfXQ4hBhJbT8MRMMMjWj46NOhZBARORI/XJEuaugeh/RHBnsYNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714582873; c=relaxed/simple;
	bh=5x+R/tulRuIaS8VcnMqYfEwZKfLlmJE83wErUp3TIJI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=RS4GVgKT+nPg4p8D4Valiw2t4ABPtVDdiA95g3gsP8jdJRWTyWWESXP6w2vRb6y+MF2MPUNjo7qb/ttyYjxaCIjErO1GesmxaB5IJqz4Ab06lGKiLyv8OwkJpj6novam7NG6QZwGbEseDQjma6OT466LdFIb0aHiIjJ2VzgAK/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MSRxgjH8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714582869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbBAwD6JC5VL1ukHU3KFqlt1QekHLcO5vtkGzyQGBMM=;
	b=MSRxgjH8KQNJt6sQg2HXSn/6qaVMrp4UTkCQsEZ66b7kd1lmeiKL+uH0Z71Q6hDiBaJzCH
	aGt7t68XSylcdsr8TvCfIBT9szDAZ4msy4RGS22FOvpRPSI4AcKJwBeUc+is388te6XMdC
	wP2aCuyyF7RuGXkFFggKymffsIGqceI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-jValeIcOO1Sva0kNIIWiZg-1; Wed, 01 May 2024 13:01:07 -0400
X-MC-Unique: jValeIcOO1Sva0kNIIWiZg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 014948948A6;
	Wed,  1 May 2024 17:01:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.22])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 512842166B31;
	Wed,  1 May 2024 17:01:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240430140056.261997-15-dhowells@redhat.com>
References: <20240430140056.261997-15-dhowells@redhat.com> <20240430140056.261997-1-dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
    Gao Xiang <hsiangkao@linux.alibaba.com>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Matthew Wilcox <willy@infradead.org>,
    Steve French <smfrench@gmail.com>,
    Marc Dionne <marc.dionne@auristor.com>,
    Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
    linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
    linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
    ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
    linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
    linux-mm@kvack.org, netdev@vger.kernel.org,
    linux-kernel@vger.kernel.org, Latchesar Ionkov <lucho@ionkov.net>,
    Christian Schoenebeck <linux_oss@crudebyte.com>
Subject: Re: [PATCH v2 14/22] netfs: New writeback implementation
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <458059.1714582859.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 May 2024 18:00:59 +0100
Message-ID: <458060.1714582859@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

This needs the attached change.  It needs to allow for netfs_perform_write=
()
changing i_size whilst we're doing writeback.  The issue is that i_size is
cached in the netfs_io_request struct (as that's what we're going to tell =
the
server the new i_size should be), but we're not updating this properly if
i_size moves between us creating the request and us deciding to write out =
the
folio in which i_size was when we created the request.

This can lead to the folio_zero_segment() that can be seen in the patch be=
low
clearing the wrong amount of the final page - assuming it's still the fina=
l
page.

David
---
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 69c50f4cbf41..e190043bc0da 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -315,13 +315,19 @@ static int netfs_write_folio(struct netfs_io_request=
 *wreq,
 	struct netfs_group *fgroup; /* TODO: Use this with ceph */
 	struct netfs_folio *finfo;
 	size_t fsize =3D folio_size(folio), flen =3D fsize, foff =3D 0;
-	loff_t fpos =3D folio_pos(folio);
+	loff_t fpos =3D folio_pos(folio), i_size;
 	bool to_eof =3D false, streamw =3D false;
 	bool debug =3D false;
 =

 	_enter("");
 =

-	if (fpos >=3D wreq->i_size) {
+	/* netfs_perform_write() may shift i_size around the page or from out
+	 * of the page to beyond it, but cannot move i_size into or through the
+	 * page since we have it locked.
+	 */
+	i_size =3D i_size_read(wreq->inode);
+
+	if (fpos >=3D i_size) {
 		/* mmap beyond eof. */
 		_debug("beyond eof");
 		folio_start_writeback(folio);
@@ -332,6 +338,9 @@ static int netfs_write_folio(struct netfs_io_request *=
wreq,
 		return 0;
 	}
 =

+	if (fpos + fsize > wreq->i_size)
+		wreq->i_size =3D i_size;
+
 	fgroup =3D netfs_folio_group(folio);
 	finfo =3D netfs_folio_info(folio);
 	if (finfo) {
@@ -342,14 +351,14 @@ static int netfs_write_folio(struct netfs_io_request=
 *wreq,
 =

 	if (wreq->origin =3D=3D NETFS_WRITETHROUGH) {
 		to_eof =3D false;
-		if (flen > wreq->i_size - fpos)
-			flen =3D wreq->i_size - fpos;
-	} else if (flen > wreq->i_size - fpos) {
-		flen =3D wreq->i_size - fpos;
+		if (flen > i_size - fpos)
+			flen =3D i_size - fpos;
+	} else if (flen > i_size - fpos) {
+		flen =3D i_size - fpos;
 		if (!streamw)
 			folio_zero_segment(folio, flen, fsize);
 		to_eof =3D true;
-	} else if (flen =3D=3D wreq->i_size - fpos) {
+	} else if (flen =3D=3D i_size - fpos) {
 		to_eof =3D true;
 	}
 	flen -=3D foff;


