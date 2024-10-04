Return-Path: <ceph-devel+bounces-1884-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17CCE9907EE
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Oct 2024 17:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFA4E28B042
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Oct 2024 15:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8762D21B44C;
	Fri,  4 Oct 2024 15:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISZ4oeb3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3D31CACE4
	for <ceph-devel@vger.kernel.org>; Fri,  4 Oct 2024 15:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728056257; cv=none; b=pGyEpZLf6IYFShcTS/SZ7oiM4gvKgMeoXI3BZVKOVwKR7wIwKqSDSnxVXFW5pwzVVMrkSgRSbcIR0p13YZjJS7P9Mj5MQZblLSR+n4Yt/X0Ok+l/OMyimWoF+m4IJ3/xmYV9anqim8lgmr4WArL2+a23xOgN0SdFTOdOnWeUCUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728056257; c=relaxed/simple;
	bh=0D1cYSeQQ+jhwWd4TLI5hO7NsEF3R3zty8OXiKh3+ps=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=BLptfiG3oDZNNfSlHqVMRHWFqzX0Ec28pE1076/JTGIRubBcR8cstRYmsWV2v9BJOiR/XJxmVrTdR3ragrsSB4nRJoA6kg5JFMjSAJj0zmm3DFAjUDlrMX7SW+qU0rLeyqx/6INTDxwqup920kCdr1VSsxkSbFG1vem5bQjOUzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ISZ4oeb3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728056255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0D1cYSeQQ+jhwWd4TLI5hO7NsEF3R3zty8OXiKh3+ps=;
	b=ISZ4oeb3sril25uP10lrVr0l9sn/EMQM5IGHls7rCxlNXu+P2U4RwJExM4iIhRm3SaOYQn
	CEnYj0DfA5oryQKTbLHLzkD8RfXwF53JIjmOaBns8HsiYNjw02wGScZmnUynwqXh+QAj5w
	FQRVtl7iGN2L9gk/JzGZ8Wk0uDGsV3E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-5Gug8Q8zOBabFupWhhPBXw-1; Fri,
 04 Oct 2024 11:37:31 -0400
X-MC-Unique: 5Gug8Q8zOBabFupWhhPBXw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 565A61955EB5;
	Fri,  4 Oct 2024 15:37:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.145])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 37C221956054;
	Fri,  4 Oct 2024 15:37:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20241003010512.58559-1-batrick@batbytes.com>
References: <20241003010512.58559-1-batrick@batbytes.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: dhowells@redhat.com, Xiubo Li <xiubli@redhat.com>,
    Patrick Donnelly <batrick@batbytes.com>,
    Jeff Layton <jlayton@kernel.org>,
    Patrick Donnelly <pdonnell@redhat.com>, stable@vger.kernel.org,
    ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ceph: fix cap ref leak via netfs init_request
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3822913.1728056247.1@warthog.procyon.org.uk>
Date: Fri, 04 Oct 2024 16:37:27 +0100
Message-ID: <3822914.1728056247@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi Ilya,

Are you going to pick this up, or should I ask Christian to take it through
the vfs tree?

David


