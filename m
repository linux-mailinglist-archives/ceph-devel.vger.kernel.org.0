Return-Path: <ceph-devel+bounces-2530-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B69A19A8D
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jan 2025 22:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D884F3A3B77
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jan 2025 21:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D6E1C5F12;
	Wed, 22 Jan 2025 21:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UGYx+Haf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0F11C5D66
	for <ceph-devel@vger.kernel.org>; Wed, 22 Jan 2025 21:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737582934; cv=none; b=TUhr/NYwhNyTl4uaFFg3b3oUxe6U7SrwrxwXYOwpWBe3K6pW5KzamelqNENpwx97hV1Iuu00sHec6C5/Vlh6pPnsUUcZsB8FoYTScPqaBdiBphhYqMqzJT01TSPa6us/qnenKBI96nViT/3yKuvtjUy0Deyo28R+NYxDhtlVum0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737582934; c=relaxed/simple;
	bh=K6EBd5kiOgV0r6ZXDV6KgpG45Jljbse2QNGT5zRtOYQ=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=EnPrH2Lds2iyMREpcdmLp5LEGlKvaQRg96jD5fbRdQfdswq62WUlRjf9I8h6fGcznvzY8Et/JMVsYONivcayJ4beausDEqTRpB0wpubcUiv/0nnw0bHdpLkqA9Ok93QXQ4iyTIhXhNlMrLj9hoQsgAlY6N2YQAfM/hitnMsLWmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UGYx+Haf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737582931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iqy7klWixnSIoxs/rjU0d28OWEIyXOR/CnRyAJATpCI=;
	b=UGYx+HafSub+p92mFxrqSZ8jbAikAXUSLL+sDaKb/xtHEKKZkmUYCkYT58WSqR4P95g0vP
	Zse8nVukKCkVrU0cCVmmkl9gIrJPt/LGDyaQWKhvApHMLQ6VaOpKQVwB+Y5KjuzL6Bd8p9
	5zcwA0PCX9ZyRiMRD4xOuH7sk6IuDS8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-YDntbf-yNWW2QWG8K9bb9A-1; Wed,
 22 Jan 2025 16:55:29 -0500
X-MC-Unique: YDntbf-yNWW2QWG8K9bb9A-1
X-Mimecast-MFC-AGG-ID: YDntbf-yNWW2QWG8K9bb9A
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC95A19560B9;
	Wed, 22 Jan 2025 21:55:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 89D0219560AA;
	Wed, 22 Jan 2025 21:55:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250122212456.GA1977892@ZenIV>
References: <20250122212456.GA1977892@ZenIV> <20250116052317.485356-8-viro@zeniv.linux.org.uk> <20250116052103.GF1977892@ZenIV> <20250116052317.485356-1-viro@zeniv.linux.org.uk> <2066311.1737577661@warthog.procyon.org.uk> <20250122210124.GZ1977892@ZenIV>
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
Content-ID: <2072041.1737582922.1@warthog.procyon.org.uk>
Date: Wed, 22 Jan 2025 21:55:22 +0000
Message-ID: <2072042.1737582922@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Al Viro <viro@zeniv.linux.org.uk> wrote:

> IOW, are you OK with the following?
> 
> commit bf61e4013ab1cb9a819303faca018e7b7cbaf3e7
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Fri Jan 3 00:27:27 2025 -0500
> 
>     afs_d_revalidate(): use stable name and parent inode passed by caller
>     
>     No need to bother with boilerplate for obtaining the latter and for
>     the former we really should not count upon ->d_name.name remaining
>     stable under us.
>     
>     Reviewed-by: Jeff Layton <jlayton@kernel.org>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: David Howells <dhowells@redhat.com>


