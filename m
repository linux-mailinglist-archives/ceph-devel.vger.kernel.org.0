Return-Path: <ceph-devel+bounces-2527-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F96A199DB
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jan 2025 21:28:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E4BB165393
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jan 2025 20:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6313D2144A2;
	Wed, 22 Jan 2025 20:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QWRtYCFc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E85B1EB2F
	for <ceph-devel@vger.kernel.org>; Wed, 22 Jan 2025 20:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737577676; cv=none; b=PKwKubPnQRT2hGAl9ME7ImgHqsOMZ9Lnnx0ciEFKXxVzfDJzH4awhLBnmCREY4HTGv8H/d9u7fdzDw/nEashdCGvH26v2db7tsExV5XdtJd7pQHkiuK+gTeCccP8CHNeof2pNvqri8zUqhdY1OIdXI3Se2HcJAC1ESaOmA+k0Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737577676; c=relaxed/simple;
	bh=IcSmQWZvD1s1DOjMFYKRMAx529EfOSoj4hHuj59R2Ow=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=bHXjWZYKpfgGJjpb/s+4CRecDj9PwCob43TwIPfJRonGhAwiQosIeO7WRGMOCmYMZRUPz2JTukCfxNUGyHC9SFXrxAOJ7EARd2dplgIAnkwX1MOJOGN9MYN+oIvOqt2o1A3yaEBYmvDG7mw9X/BIWnlzjUAAjjEWMF7Ns3O9EC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QWRtYCFc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737577673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aO6H+wNayAwwxcRPzHlCO5PB3+evwKh+z36TdfnPnPM=;
	b=QWRtYCFc/O0jhs8VqB66aKGzmn5jRZyEP8qvEwW0b2yG4uikviVhLbejbXRMd1f44QLgl2
	pTgc6WD+krGlET5+tQ/A4XJb4L8c32EiOQdpFsDgE6Swc/QZ7K+Dtj4p4frpS7r2JiWpqE
	diB7AkeWKB7MtWJ2lO+TlYXSBjvdGJk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-ZYgrOmJbPfKXF5hLVLIJKQ-1; Wed,
 22 Jan 2025 15:27:48 -0500
X-MC-Unique: ZYgrOmJbPfKXF5hLVLIJKQ-1
X-Mimecast-MFC-AGG-ID: ZYgrOmJbPfKXF5hLVLIJKQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C1341955DCC;
	Wed, 22 Jan 2025 20:27:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7A7219560AA;
	Wed, 22 Jan 2025 20:27:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250116052317.485356-8-viro@zeniv.linux.org.uk>
References: <20250116052317.485356-8-viro@zeniv.linux.org.uk> <20250116052103.GF1977892@ZenIV> <20250116052317.485356-1-viro@zeniv.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
    agruenba@redhat.com, amir73il@gmail.com, brauner@kernel.org,
    ceph-devel@vger.kernel.org, hubcap@omnibond.com, jack@suse.cz,
    krisman@kernel.org, linux-nfs@vger.kernel.org, miklos@szeredi.hu,
    torvalds@linux-foundation.org
Subject: Re: [PATCH v2 08/20] afs_d_revalidate(): use stable name and parent inode passed by caller
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2066310.1737577661.1@warthog.procyon.org.uk>
Date: Wed, 22 Jan 2025 20:27:41 +0000
Message-ID: <2066311.1737577661@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Al Viro <viro@zeniv.linux.org.uk> wrote:

> -	_enter("{%lu},%p{%pd},", dir->i_ino, dentry, dentry);
> +	_enter("{%lu},{%s},", dir->i_ino, name->name);

I don't think that name->name is guaranteed to be NUL-terminated after
name->len characters.  The following:

	_enter("{%lu},{%*s},", dir->i_ino, name->len, name->name);

might be better, though:

	_enter("{%lu},{%*.*s},", dir->i_ino, name->len, name->len, name->name);

might be necessary.

Apart from that:

Acked-by: David Howells <dhowells@redhat.com>


