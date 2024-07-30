Return-Path: <ceph-devel+bounces-1616-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64B6F941593
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 17:41:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7B18B21432
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 15:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A25FB1A2C1A;
	Tue, 30 Jul 2024 15:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AtSJV2C5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21CA18A92F
	for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354084; cv=none; b=inNKiJ0NbU0z45cgcm5VoXZi7umadALP83iyN1fW4hG3YcL+IzV/wZfbZSS//h3epxw8wjwjQUzcjyd1U7l7F8KL8k0XhERfa5CofzhiTRUy69XokozeCP4VQBYV5d/Xe3PnxDl/qLvktXZmY4yIsgD+/4suldQwobywfePF43E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354084; c=relaxed/simple;
	bh=ajVW/Twg9kyeIBsINLqc9i2LrtkZwqPRQKXCgiMS69U=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=KkQngPr2bJ8gDnqsOaAMXfCdwBBDUoOiGxm4tEIg0Cyq5wm0TmSLWGOSVmy9oB/6uihG/gyG9c0YPJGwoUxqlQnj5b1gMeT0DTCOhnsKs/hIhSBd+moHFws97mb0kjcpNKK1HQZsaWFRZqmkaG5VVivQTqbXXh3n36+XFXzaFgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AtSJV2C5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722354082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0mB5yq5YiVF6hgMMbOMHQ2v9K7FPCMyb/XiuYsldEd0=;
	b=AtSJV2C5rHJrIqnvxXqrfSPAIyCzHVJZAaD0cLNyyyDTgvaYgBNftJj5c37PqFgD85OWeO
	swhcZXhbpmVShs4jKGi7NRE6eeJtni7hrYKEDmpsVWwS150GOwCG8Pemx7hD/51rHl5WdT
	CETCmvJlRieicBJEcjbaDekOcizHIIY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-338-PKs2OiCNM3OTGBYH9YTL8g-1; Tue,
 30 Jul 2024 11:41:17 -0400
X-MC-Unique: PKs2OiCNM3OTGBYH9YTL8g-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 412451955D48;
	Tue, 30 Jul 2024 15:41:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.216])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E59D1955D42;
	Tue, 30 Jul 2024 15:41:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3516608.1722349609@warthog.procyon.org.uk>
References: <3516608.1722349609@warthog.procyon.org.uk> <20240729090639.852732-1-max.kellermann@ionos.com>
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
Content-ID: <3554543.1722354072.1@warthog.procyon.org.uk>
Date: Tue, 30 Jul 2024 16:41:12 +0100
Message-ID: <3554544.1722354072@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

I think the right thing to do is probably to at least partially revert:

	ae678317b95e760607c7b20b97c9cd4ca9ed6e1a
	netfs: Remove deprecated use of PG_private_2 as a second writeback flag

for the moment.  That removed the bit that actually did the write to the
cache on behalf of ceph.

David


