Return-Path: <ceph-devel+bounces-2508-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7909BA15902
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2025 22:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2570166A23
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2025 21:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64A01AA1F1;
	Fri, 17 Jan 2025 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sl5lkSk9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C5E19E7D1
	for <ceph-devel@vger.kernel.org>; Fri, 17 Jan 2025 21:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737149400; cv=none; b=QwX9XDadhqKD6xZnYEVdRvTExygTO2Am8tFq7/myKVud0078DbZnXsobT5aGfteN0vAcj4bg7cY4F401uiKBdRsQe5YZQPeSQQm6FpRhYMzx55bCllY8yr+PshwyaD2k3p+vrGliDvST+H+HEEq8Kw/i+RzJTss0QyBKqi2aDvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737149400; c=relaxed/simple;
	bh=O9fBo5JI4CXzTDxOTycsR9bVLVyGTuOYwP7a6sID3Ro=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=s9RVSv71tCAf0Si5K5fs5uJJqHJyJdNG+zgUM+4ik0MAXQHwqC9tsc6R7MRFOdcLMvw5JFYPBsfdyt26JJuy3rG/Mjw8Z/ZDa4rNLFpaEm5CMfqVjMGJk8x7p8GCAEvCuNaQFB4NnU+EcQ4DtM+bo2AOLadR3nCsxmocxuPCmYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sl5lkSk9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737149398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O9fBo5JI4CXzTDxOTycsR9bVLVyGTuOYwP7a6sID3Ro=;
	b=Sl5lkSk9TZ6bN11RaGHkTVUmoZXnSdfR7CzqQG+6F3qYxk64detv40hi2Skwmx4NuFJ0ZH
	l0xJIA5Qrt6PAWAzsH4bhanKYRT5HyQ8glvQICA+pp4rx3b/bEmD5i3PpD9qBOz335/E9m
	g5i05iJqra9p1GihTi25KMe0tX0tJpY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-xfl1hUDPPJSbcFFOQT9V5Q-1; Fri,
 17 Jan 2025 16:29:56 -0500
X-MC-Unique: xfl1hUDPPJSbcFFOQT9V5Q-1
X-Mimecast-MFC-AGG-ID: xfl1hUDPPJSbcFFOQT9V5Q
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5635819560B2;
	Fri, 17 Jan 2025 21:29:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4519E1955F10;
	Fri, 17 Jan 2025 21:29:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOi1vP9jKOuBetRPZCDeUAdiOmQTYLKSSgX4YYQFt72H-t_j6A@mail.gmail.com>
References: <CAOi1vP9jKOuBetRPZCDeUAdiOmQTYLKSSgX4YYQFt72H-t_j6A@mail.gmail.com> <266c50167604c606c95a6efe575de5430c31168b.camel@ibm.com> <CAOi1vP-=8QLaQqYTrZpe6s=hkAmNm8Z-upOeQvTQYY-uosxg8A@mail.gmail.com>
To: Ilya Dryomov <idryomov@gmail.com>,
    Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: dhowells@redhat.com,
    "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
    Alex Markuze <amarkuze@redhat.com>,
    "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
    "slava@dubeyko.com" <slava@dubeyko.com>
Subject: Re: [RFC PATCH] ceph: Fix kernel crash in generic/397 test
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <887370.1737149392.1@warthog.procyon.org.uk>
Date: Fri, 17 Jan 2025 21:29:52 +0000
Message-ID: <887371.1737149392@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Note that netfslib provides some tracepoints that you can use to try and
illuminate what's going on there.

echo 1 > /sys/kernel/debug/tracing/events/netfs/netfs_read/enable
echo 1 > /sys/kernel/debug/tracing/events/netfs/netfs_rreq/enable
echo 1 > /sys/kernel/debug/tracing/events/netfs/netfs_sreq/enable
echo 1 > /sys/kernel/debug/tracing/events/netfs/netfs_failure/enable

for starters.

David


