Return-Path: <ceph-devel+bounces-3607-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C82DB56824
	for <lists+ceph-devel@lfdr.de>; Sun, 14 Sep 2025 13:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8C38189AD5F
	for <lists+ceph-devel@lfdr.de>; Sun, 14 Sep 2025 11:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B734F243376;
	Sun, 14 Sep 2025 11:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grouphealthprimerobust.co header.i=@grouphealthprimerobust.co header.b="VXiJybqz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.example.org (outbound.grouphealthdevotedtrust.co [51.161.73.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E14124338F
	for <ceph-devel@vger.kernel.org>; Sun, 14 Sep 2025 11:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.161.73.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757850736; cv=none; b=di3Z+fNHy7F3XLpD4OCfzaQnL/+RD6ryB5kacHyeU9Xhm5veLIdUs7Z4pMSsviSWu1JD0KKh7lGRHgzSr5av6DcKEo8hCGMNoXQzNBR7SRNGNnNqJmSEUibnLFgBHw5m0j+ef5kDgwt43AjWAXGrx5dbi1wHQVvgqUMiXjl65e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757850736; c=relaxed/simple;
	bh=xi4Mt3y3JeXGwEcb5vBwUsJgCHjZTYrhEyOQgAtA9Yk=;
	h=Message-ID:From:To:Subject:Date:MIME-Version:Content-Type; b=Zhfi5pxKYn/LRrY+TiVwOEmEeJMOZ1xrGmdpczbe01hh+Snrx2LSqKM77xF30H8I5VLibTlf7M0q3mNucmWF9CfU7gMQ3vnjA3ai9p7VHe6kMgMZmZtdJX33PfXx4aYsBfmtsGnEuQj0mbbu6rib1ABsZSbOHYcKsQJntdciYmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grouphealthprimerobust.co; spf=pass smtp.mailfrom=grouphealthprimerobust.co; dkim=pass (2048-bit key) header.d=grouphealthprimerobust.co header.i=@grouphealthprimerobust.co header.b=VXiJybqz; arc=none smtp.client-ip=51.161.73.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grouphealthprimerobust.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grouphealthprimerobust.co
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grouphealthprimerobust.co;
	s=mail; t=1757850342; h=from:subject:date:message-id:to:mime-version:content-type:
	 content-transfer-encoding; bh=xi4Mt3y3JeXGwEcb5vBwUsJgCHjZTYrhEyOQgAtA9Yk=;
	b=VXiJybqzPt/ZRYdKru+pNJ7MiTg8m7kpTPClPP8YMXHuhgMi+1XQxx6cOm4to/C9UdZiAO
	jBFYm99aMtG2qzx2gpgrY7efvd9fK3Vn+/E4jiF7xG9h48/+lIaGy+HOKcJ5LPiizrw0X0
	Pz5QKd4TsanktG+HyGk5A1Tfym14WfSsrS7n92OqVRgxAOSvnN/2KEWFw6ukUXF9kE+n9t
	4ZR8Gxuefa38HqiPIQWKACmfNeU7Bx/WGDmcjPIJPpmBOlFrc3XRToS+gUhPmxTKFaaztY
	bwBnuWCmjFMqwr4vHfE0ZVU7x5wRft7y+Aj3Id8K4C/0Gpa589ELfP9CUfVImw==
Message-ID:
 <0199480b-8ea8-7287-aeef-c05ff9f490ac@grouphealthprimerobust.co>
From: Cynthia Miller <cynthia.miller@grouphealthprimerobust.co>
To: ceph-devel@vger.kernel.org
Subject: funding for Ceph Storage Ceph Storage
Content-Transfer-Encoding: quoted-printable
Date: Sun, 14 Sep 2025 11:45:41 +0000
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Last-TLS-Session-Version: TLSv1.3

We fund based on revenue credit does not matter. Provided Ceph Storage has =
been in business for at least 4 months, we=E2=80=99re able to provide =
funding within 24 hours or less.

Should I forward a short summary, or =
would you rather have a short conversation?

Thank you, Cynthia Miller =
Co-Partner @ Gova Funding

If this isn=E2=80=99t a fit, just reply "not the=
 right time" and you won=E2=80=99t hear from me again.


