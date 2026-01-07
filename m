Return-Path: <ceph-devel+bounces-4278-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A02CFDA8E
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 13:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F0ED9300285A
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jan 2026 12:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3968D310774;
	Wed,  7 Jan 2026 12:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mor-monshizadeh.awsapps.com header.i=@mor-monshizadeh.awsapps.com header.b="qVxOQ/gn";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="SZBIpJbT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from a8-99.smtp-out.amazonses.com (a8-99.smtp-out.amazonses.com [54.240.8.99])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E952F531B
	for <ceph-devel@vger.kernel.org>; Wed,  7 Jan 2026 12:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767788918; cv=none; b=AHH4iCy0XA3YioRGt7PT/FH83QkIzza30ZGup2SWn4jxSgm9xJ7Y+1hQkJRt6zpXCJHpoD5RWMJqKzfb3xcLhiuRyhcQRcL1onQLqpOnvYyWyHKXJfE9w95nkvA6L6JtMtiDFrdsP7+OxH1UnoEnbkVvXIY1Euo0uwFNpZqBUVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767788918; c=relaxed/simple;
	bh=eFyF+WIpSmeU5uEJm1D8zQ8O7jBkXjxWhSV0tKwJdc4=;
	h=From:To:Subject:MIME-Version:Content-Type:Message-ID:Date; b=N0SqCcfvf67BewRwlXSHT1UQRhNwnjYmkMN+DI0H4azcqkYjli/Rt9jDM/WDSQP2bGl4haisxf3cEMsIOSOr+zmhck/hoCkTs1RGJm1p4wnRAQmgiR9hhCP/0g9P4V2YBwqtDEX+outg38gFe56cxUXVuxLzGOpa6STuor9A7vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mor-monshizadeh.awsapps.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (2048-bit key) header.d=mor-monshizadeh.awsapps.com header.i=@mor-monshizadeh.awsapps.com header.b=qVxOQ/gn; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=SZBIpJbT; arc=none smtp.client-ip=54.240.8.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mor-monshizadeh.awsapps.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=otgjlvbj5l3ylp2aadnsmg6qcrbd6yx5; d=mor-monshizadeh.awsapps.com;
	t=1767788915;
	h=From:To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID:Date;
	bh=eFyF+WIpSmeU5uEJm1D8zQ8O7jBkXjxWhSV0tKwJdc4=;
	b=qVxOQ/gnRTNEdEq7a1nEbovUOzd47F7jKo5i8hTsRScvpV/pi1fCFUu/A3Q0JJHk
	ylO8YFz+rwm7AR8FNhJmWfMCjctE+Y99eXlRPQXa1RwRUjaol5EJjMXCQtVWFR1b2AY
	RqRwd9pnygn0oooAdaV67sLZ7NvOV69/AyUy06RE9rKn1DOeaobsotiPE8d380Aub/x
	SWVzqaKja6FXF3UR3a/x2r7LaV34SwN0I2pAVmQmMYsKDuxZTd1aBKcKb++wf2c/UrM
	rUa0N/V0kGGKHYsmFd/+KL/itiZUP5oCmrmJzxmMEDGOQjtYBtExkJzFLnwRBXLcHhE
	6KsNx6nDdg==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=6gbrjpgwjskckoa6a5zn6fwqkn67xbtw; d=amazonses.com; t=1767788915;
	h=From:To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID:Date:Feedback-ID;
	bh=eFyF+WIpSmeU5uEJm1D8zQ8O7jBkXjxWhSV0tKwJdc4=;
	b=SZBIpJbTd3yccAHCO/7jo0zgFTBn3fVz7H/C+RmAi7Vc/RLDZ+Fbgg6UF1ZjdzSv
	xLiF5b47x3Q33dQ8kFcYX0KexlxU3zCUNR6mfkYppCyk3JmmXpLlkIaQ6JKhjCi//bk
	XI88iquz8xoiHnRoJptQ6OnR3sGmpqJutKftR2QA=
From: Mor Monshizadeh - MorVoice <mor@mor-monshizadeh.awsapps.com>
To: ceph-devel@vger.kernel.org
Subject: Quick question about a free voice AI tool
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Message-ID: <0100019b986e2b75-2f83d62e-eb9f-49da-908d-2da889007103-000000@email.amazonses.com>
Date: Wed, 7 Jan 2026 12:28:35 +0000
Feedback-ID: ::1.us-east-1.COxcueGel0S2JrZtthAymE0xHFZdX9PuxyrqmFHAJQI=:AmazonSES
X-SES-Outgoing: 2026.01.07-54.240.8.99

Hi there,

I'm Mor Monshizadeh, CTO at MorVoice.

I came across ceph.com while browsing audio/AI tools and thought MorVoice m=
ight genuinely be useful for your audience.

MorVoice.com is built to make high-quality voice AI accessible=E2=80=94so c=
reators aren't stuck paying enterprise pricing to get something usable. If =
you're open to it, could you try it for two minutes? If it feels like a fit=
, even a short mention or a link on a resources/tools page would mean a lot=
.

Check it out: www.morvoice.com

Happy to return the favor as well:

=E2=80=A2 Feature you in our Supporters directory
=E2=80=A2 Reciprocal backlink from MorVoice.com
=E2=80=A2 MOR crypto tokens as a thank-you (only if that aligns with your p=
olicy)

If you're open to a link, what's the best page on your site for a resources=
/tools mention?

Best,
Mor Monshizadeh
CTO, MorVoice
www.morvoice.com
mor@morvoice.com

