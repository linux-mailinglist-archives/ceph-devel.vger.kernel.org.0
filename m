Return-Path: <ceph-devel+bounces-1802-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC45396F932
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 18:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 540A2B23DA9
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 16:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5481D3633;
	Fri,  6 Sep 2024 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MYPNrhhg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C892E1D3621
	for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2024 16:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725639788; cv=none; b=RYh0BF1K3LtxJGkFA48wkugxHEcOYXqkPpvxSd8sj7tS0s8n1DSOHbQndPTNlyUNwglEWYtoabtUoxPtm8EC4q1uuETQek7wy12Ru6uXkv9LEfhgutwkXp9E9NTHuAM+g2eWNjbaa/g69eMqhbJpG6uzDQmaNC/L6guNQyrUA+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725639788; c=relaxed/simple;
	bh=fS/zCZRcdqBRpXPYngRBghtR8qMeqNGYgofN4G8HWzs=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=o3X5g31w81hvWc0VYhpkAdq9QgRKfGY3CpIZPLzCM7CxS6YdZInlB4oXtYmULmEO1nt211JGVhivwCiFR6RR/2XZgswihktWrMm6asdDI+r8fhqNMwkmckTF9ca+CoZf17gb8qgH2XjP++VCEZUF14ZmFMEWk4gbzIBvDjFdg/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MYPNrhhg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725639785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fS/zCZRcdqBRpXPYngRBghtR8qMeqNGYgofN4G8HWzs=;
	b=MYPNrhhgfiDcKJmS0nyCiHjGLw3t9pParDP+cigxL8EltjPtYIbRjoOJB78IUAxGIjYSJ7
	90q11rJDQBSW5mPyuLLC5B6dylO34Rc3s/OPYnRKR13WI+Q+UG91GWa9ZDnBsprPC+CNxD
	smCenU/2//pCOIIgScaf8cDnjJMMlZ4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-ka47LoxQP1qgVe7ZYMxK4g-1; Fri,
 06 Sep 2024 12:23:02 -0400
X-MC-Unique: ka47LoxQP1qgVe7ZYMxK4g-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF6481955F43;
	Fri,  6 Sep 2024 16:23:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AA7EB1956048;
	Fri,  6 Sep 2024 16:22:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <85bef384-4aef-4294-b604-83508e2fc350@proxmox.com>
References: <85bef384-4aef-4294-b604-83508e2fc350@proxmox.com>
To: Christian Ebner <c.ebner@proxmox.com>
Cc: dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
    Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
    regressions@lists.linux.dev, ceph-devel@vger.kernel.org,
    stable@vger.kernel.org
Subject: Re: [REGRESSION]: cephfs: file corruption when reading content via in-kernel ceph client
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <127720.1725639777.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Sep 2024 17:22:57 +0100
Message-ID: <127721.1725639777@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Christian Ebner <c.ebner@proxmox.com> wrote:

> some of our customers (Proxmox VE) are seeing issues with file corruptio=
ns
> when accessing contents located on CephFS via the in-kernel Ceph client =
[0,1],
> we managed to reproduce this regression on kernels up to the latest 6.11=
-rc6.
> Accessing the same content on the CephFS using the FUSE client or the
> in-kernel ceph client with older kernels (Ubuntu kernel on v6.5) does no=
t show
> file corruptions.

Are they using local caching with cachefiles?

David


