Return-Path: <ceph-devel+bounces-3847-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6EEBEC73E
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Oct 2025 06:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76B4E6E191E
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Oct 2025 04:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DD925A322;
	Sat, 18 Oct 2025 04:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grouphealthensuretrust.co header.i=@grouphealthensuretrust.co header.b="Zc0aTksf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from outbound.grouphealthaidshield.com (outbound.grouphealthaidshield.com [51.161.73.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7D41448E0
	for <ceph-devel@vger.kernel.org>; Sat, 18 Oct 2025 04:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.161.73.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760762094; cv=none; b=lMottYRaxoEevCMASncslPEIvprMHFYjOFEB/wTXEvs+02B5X+AwAunTYqal5wBmnPqb9Os8S93zgMgCsJuClJ0/CfZCa2UFWloOwgw7vFBmIw8xs7lsvCbsuqdm4e3YjV1qBxLO62n5BvBLtyPzuPj0tmLp0MvP1hoYS7bPydk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760762094; c=relaxed/simple;
	bh=oj1LjLGZlp36yyGFQUrv+jAjMdKdV7wGe5iIJMVEkF4=;
	h=Message-ID:From:To:Subject:Date:MIME-Version:Content-Type; b=qhuhRCaBHpl9AJ0OWhy80W6Kh/vMfPs1j4A7Bb4YoWDTtzCAOq/cJLG8OuMp2+XV8KDY4rFZVjFoQHD6wyRHUjoaGFfIczkRvzMyDhgCjp/xZkjAJIWbhbRB46oSqU5DlDYFe+NPA5daFtCxYqzwlwfd6W8KsUd4yKaAmPf6FyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grouphealthensuretrust.co; spf=pass smtp.mailfrom=grouphealthensuretrust.co; dkim=pass (2048-bit key) header.d=grouphealthensuretrust.co header.i=@grouphealthensuretrust.co header.b=Zc0aTksf; arc=none smtp.client-ip=51.161.73.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grouphealthensuretrust.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grouphealthensuretrust.co
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grouphealthensuretrust.co;
	s=mail; t=1760761514; h=from:subject:date:message-id:to:mime-version:content-type:
	 content-transfer-encoding; bh=oj1LjLGZlp36yyGFQUrv+jAjMdKdV7wGe5iIJMVEkF4=;
	b=Zc0aTksf828QU/NlQ7IF/E2SIjb+ywoKejRGRQXl3DysVfUk0zdD7pC+n1SOPOK79cvcqQ
	55FurX8faUMfyWaywnLjDajgPhmJAGXYTXz47/MOTptFNRpNzKCyKuJxlN5knwR+Rkd6T5
	OeB02KfihLMEJ5w4xd2/L6rGQQ7Mcy4Wiqpz7xd4EbafA6JG7qhYZby6uZx/aVP77S8HDU
	sYVexc2q+GjR51IpobR5lKRoG41i4GM0uL5tIyjmgmaSNtZc8VRralSZQ/kZrCmTgyOTK/
	g9vnZNWm8KuZSVE8NFXm/mYHupF3sbV5/AeU+VbKaRVnvy98XAcsCF5gKPCFBQ==
Message-ID:
 <0199f590-83af-766e-a388-90c22e1951f1@grouphealthensuretrust.co>
From: Dorothy Thompson <dorothy.thompson@grouphealthensuretrust.co>
To: ceph-devel@vger.kernel.org
Subject: Funding for Ceph Storage
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Oct 2025 04:25:12 +0000
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Last-TLS-Session-Version: TLSv1.3

Hi, quick ask: are you the appropriate person at Ceph Storage to discuss =
access to funds within 24 hours, or should I reach out to a different =
person?

To cut to the chase: my organization can facilitate funding based =
on monthly revenue, and credit score isn't a major obstacle.

So long as Ceph Storage has been doing business for a minimum of 4 months, =
you could have funds in 1 day or potentially sooner.

How about I send a short overview, or is a brief call more convenient? If =
you'd like to know more, just reply yes.

Regards,

Dorothy Thompson

