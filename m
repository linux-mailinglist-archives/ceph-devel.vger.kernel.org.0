Return-Path: <ceph-devel+bounces-1981-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 662459B1360
	for <lists+ceph-devel@lfdr.de>; Sat, 26 Oct 2024 01:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CDE61C215E4
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Oct 2024 23:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E4BA20C317;
	Fri, 25 Oct 2024 23:40:09 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from www4.stratanet.com (www4.stratanet.com [67.213.225.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574361DD0C9
	for <ceph-devel@vger.kernel.org>; Fri, 25 Oct 2024 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.213.225.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729899609; cv=none; b=bKEsnUQ1ypHHUb49oHxNfQVM57FiyVxNONg1D2wID0PW3//cX263hzrfKakIZMYfUgToxa/g8Q7hemOtpipAsQhSQZbktGsNIsNxEUkSZBbBOxVfZVDlopbK/Fj0rf8qqzXECeuy5C74qR5WWeuiqQBlFvuX3Wk+GaVXI2hKWD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729899609; c=relaxed/simple;
	bh=OD8n3cTa2GC73iDchoI0BLzBaopgC/+gShrumD9KsM4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Lnaf9V5gZ3rIHDc8+B0VWPJY3dBsTZHi2saYpy3r3AGjP9/Gze6vxbO+oklVrIhmHDqVONKhYDVaGqKrLePQuBkJSXGbOKsSws0JnylI2KM1ZIs8vi097y4TIE9tvINqnrXzeizhE5hqllUJcu+4BgfaJHVLTCeOOFlfrHll4sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cataumetca.org; spf=fail smtp.mailfrom=cataumetca.org; arc=none smtp.client-ip=67.213.225.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cataumetca.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=cataumetca.org
Received: from ec2-35-93-161-92.us-west-2.compute.amazonaws.com ([35.93.161.92]:50228)
	by www4.stratanet.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98)
	(envelope-from <info@cataumetca.org>)
	id 1t4TuY-0000000FBiH-1seu
	for ceph-devel@vger.kernel.org;
	Fri, 25 Oct 2024 17:40:06 -0600
From: Chan Moo Bahk <info@cataumetca.org>
To: ceph-devel@vger.kernel.org
Subject: =?UTF-8?B?QlVTSU5FU1PCoExBVU5DSCA=?=
Date: 25 Oct 2024 23:40:05 +0000
Message-ID: <20241025234005.424B850CF9B4D90B@cataumetca.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www4.stratanet.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - cataumetca.org
X-Get-Message-Sender-Via: www4.stratanet.com: authenticated_id: northeasternofficesupply@northeasternofficesupply.com
X-Authenticated-Sender: www4.stratanet.com: northeasternofficesupply@northeasternofficesupply.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Good day sir/madam,

I am Chan Moo Bahk. I have a lucrative business proposal deal I'd=20
like to discuss with you. I am representing a group of=20
prospective investors in the USA, Europe and Asian continent.

We are seeking a professional with whom we can be involved in=20
partnership overseas, who also has the ability to manage an=20
investment portfolio in your country. If you indicate interest,=20
send a reply only via ChanMooBahk@mail.com for more details so=20
you can have a better knowledge of who you are dealing with.

I look forward to your response if this appeals to you.

Regards

Chan Moo Bahk.
ChanMooBahk@mail.com 

