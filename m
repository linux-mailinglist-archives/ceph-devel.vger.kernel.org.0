Return-Path: <ceph-devel+bounces-1615-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D61BF941458
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 16:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90CD8286133
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 14:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E011A2571;
	Tue, 30 Jul 2024 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aRQPTTe7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13EA335D3
	for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 14:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722349621; cv=none; b=YR5cfjd0ImHRB22ijlfOn/LvrbXM6b2UJLDHf34/tAGyk/dyU4zVLcxetCfK96GSf3XiwzZWpcuaFgI70Lf7vQ5pssOinnfhadWS6nptASZgbRDTKl1J/WFPUIIpeKPiuEZVoMEEwm+xXbZ2npc2PciSVhMgTdUepQ+JEZhkI/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722349621; c=relaxed/simple;
	bh=QwOqJyMeabVVRXz2SZZrMQsxGHIjnHfDQSOp9Mld0Ok=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=sbngvbBNT76QwjBH+Hk+QGzzTIme9xZ9q4OSXDB5GJV2BUQG4tTDSzbWWRS3spLnWO3J1eSQs9HwBh1aYinD9CohonPnDyo8w09DBZ1B2NmNWvEz/7zNlRCKNvjurcOXd/Nyt4GjdoJis1cgyh1ORYPMygxgj4tix0lDvhzvdPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aRQPTTe7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722349618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HN99UYk8Kh6g/3OE9am3X/kGbGNdhXjLG7Bh6vntP4U=;
	b=aRQPTTe7x59fWJwfSJ7vHyxpYCh4yQO7916O1UbWBF4Ch2znvVwL6w3ANXE3bDjFCghFZp
	T7h+kHIm+x2BEhCDAcNajdwQXXOb7OpEMFxzuqoVZdBX4tuBi6TuTHT8O6Wghmgrk9qSVQ
	ImFewi491LftShpr9mSXGMxyM+X3wcs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-416-inhxdHUVP768Hgmk5_Y2BQ-1; Tue,
 30 Jul 2024 10:26:55 -0400
X-MC-Unique: inhxdHUVP768Hgmk5_Y2BQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 957731956080;
	Tue, 30 Jul 2024 14:26:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.216])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E4ECC1955D42;
	Tue, 30 Jul 2024 14:26:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240729090639.852732-1-max.kellermann@ionos.com>
References: <20240729090639.852732-1-max.kellermann@ionos.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: dhowells@redhat.com, jlayton@kernel.org, willy@infradead.org,
    linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
    ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
    stable@vger.kernel.org
Subject: Re: [PATCH] fs/ceph/addr: pass using_pgpriv2=false to fscache_write_to_cache()
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3516607.1722349609.1@warthog.procyon.org.uk>
Date: Tue, 30 Jul 2024 15:26:49 +0100
Message-ID: <3516608.1722349609@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

For the moment, ceph has to continue using PG_private_2.  It doesn't use
netfs_writepages().  I have mostly complete patches to fix that, but they got
popped onto the back burner for a bit.

I've finally managed to get cephfs set up and can now reproduce the hang
you're seeing.

David


