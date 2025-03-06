Return-Path: <ceph-devel+bounces-2868-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03FB1A54C8C
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 14:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA6303AE291
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 13:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B925433B3;
	Thu,  6 Mar 2025 13:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BOhvxGTG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82DB1E4AE
	for <ceph-devel@vger.kernel.org>; Thu,  6 Mar 2025 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741268928; cv=none; b=pdBgEbvyXjaDQJblasE5Rl8D6hb6NUksoZeE+6/6ZeQwYmvGhJu3rqaRVKfbdabedyBcTiPHoM+RGqhHXMkvyPSGo0h7R1ZhJXsfpCd6QNYuri5PWUtQTXe52sj5CBhR1G8+jLtU1kIv7OmlDTzO7GZn01HW2Ay61CbngGSUPCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741268928; c=relaxed/simple;
	bh=+o6WkqIB49XPWTR3gth0aOKsZCX8yZfrhX1MeQVcCuI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=cEstkkaZpE5DxeRgIp8tooGpwBIa57s5dI64IbHz3N8tmuQnCakDz/eLaHLUtkJp9ltx5+QloAtsXvbEgRlCFl7I8y+v0fS8WfpuYhco/UZJ5N5miRLqlUbvI9hGxYlaVFaZ2ENNkY4z/SLocGEZWbsdfMoxU1guxoF0ynrTdjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BOhvxGTG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741268925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UOJn3sLvhIcVBzGvoXPLfCNWG4W5Sr8ulGI85ofafqY=;
	b=BOhvxGTGHV1d4fTwYvMFvSjtpFvRIzOz0xQ7V6gFXtYf9pkOSRo3cAtc4Rkmn9IBXajH4E
	dlFbZXdblj4UuXhzkJFKvdPpQRZLnTwwNerXt1f1Y9lhCxzpTY0m0uXa62dTFRFILh1UiR
	n/wQZW1bEEeSFkrikC1bIxopP3oxBqw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-wRgdpZh3OQWfdXVYjM5HZg-1; Thu,
 06 Mar 2025 08:48:37 -0500
X-MC-Unique: wRgdpZh3OQWfdXVYjM5HZg-1
X-Mimecast-MFC-AGG-ID: wRgdpZh3OQWfdXVYjM5HZg_1741268916
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C1921956053;
	Thu,  6 Mar 2025 13:48:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.200])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50DE11955DCE;
	Thu,  6 Mar 2025 13:48:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAO8a2SjC7EVW5VWCwVHMepXfYFtv9EqQhOuqDSLt9iuYzj7qEg@mail.gmail.com>
References: <CAO8a2SjC7EVW5VWCwVHMepXfYFtv9EqQhOuqDSLt9iuYzj7qEg@mail.gmail.com> <3989572.1734546794@warthog.procyon.org.uk> <4170997.1741192445@warthog.procyon.org.uk> <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com> <4177847.1741206158@warthog.procyon.org.uk>
To: Alex Markuze <amarkuze@redhat.com>
Cc: dhowells@redhat.com, Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
    Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
    Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    Gregory Farnum <gfarnum@redhat.com>,
    Venky Shankar <vshankar@redhat.com>,
    Patrick Donnelly <pdonnell@redhat.com>
Subject: Re: Is EOLDSNAPC actually generated? -- Re: Ceph and Netfslib
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <127229.1741268910.1@warthog.procyon.org.uk>
Date: Thu, 06 Mar 2025 13:48:30 +0000
Message-ID: <127230.1741268910@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Alex Markuze <amarkuze@redhat.com> wrote:

> Yes, that won't work on sparc/parsic/alpha and mips.
> Both the Block device server and the meta data server may return a
> code 85 to a client's request.
> Notice in this example that the rc value is taken from the request
> struct which in turn was serialised from the network.
> 
> static void ceph_aio_complete_req(struct ceph_osd_request *req)
> {
> int rc = req->r_result;

The term "ewww" springs to mind :-)

Does that mean that EOLDSNAPC can arrive by this function?

David


