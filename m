Return-Path: <ceph-devel+bounces-1994-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDB39BB7EB
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Nov 2024 15:35:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7938283DCA
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Nov 2024 14:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688891B1D65;
	Mon,  4 Nov 2024 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I0Csyc5D"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C5618E359
	for <ceph-devel@vger.kernel.org>; Mon,  4 Nov 2024 14:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730730918; cv=none; b=LjWu3cQFK94oTyo1vz5W9GIpMlVrv95hcsouylzzv3NyvPVjHf7MLGAH33TSGwhTemyJkAP48cyVHulX72Au9dG8Fs7OsC/DT+LtO//3eDToehkEcxVLlaCc9g80hvhI5MeP0HT2vBMaDtZskJqWgGTq3tAjlyIPEVTqcWC4+H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730730918; c=relaxed/simple;
	bh=M82jIejFV+MChQ1/KJD8IKDnQp4OCQNY3+0ds1/tTQo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MLpr2o9rU+PHhXxpKJwEqJ8PHr7GH/wmGFvmpSiOkzbr9W1hOMcL0xpQcIIQc0oSqac9paB2v0nXzUpr5pAtVwu24vwTpCkERmbXuxEOq82E42YRI28YxrRc0kTgqohZVyeslgfQRwPrZzBVddsgjtYpzCfJqruzvrb95NYsuXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I0Csyc5D; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730730913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PagbPAUOLjNCOcfPaoot9ZhU5uAtqnI9H7IEWfp5xzI=;
	b=I0Csyc5Den/B+CJYA/BpGPOMtUVDUCrmtMLgAGJokP/M6bhkugGds+/vNyEBGGJvCUvBTm
	L8BWkpP7F57qzVBSLl/H/eJE+lh1iY17lO2Txbbr9i6DGCgp4LehsJ1VZRhVgl8y6hQejJ
	bXMIOFwzB04mJD7X2FxA1j55QYXXU7c=
From: Luis Henriques <luis.henriques@linux.dev>
To: Luis Henriques <luis.henriques@linux.dev>
Cc: Xiubo Li <xiubli@redhat.com>,  Ilya Dryomov <idryomov@gmail.com>,
  ceph-devel@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
In-Reply-To: <87ldz9ma5b.fsf@linux.dev> (Luis Henriques's message of "Mon, 30
	Sep 2024 16:30:40 +0100")
References: <20240905135700.16394-1-luis.henriques@linux.dev>
	<e1c50195-07a9-4634-be01-71f4567daa54@redhat.com>
	<87plphm32k.fsf@linux.dev>
	<bb7c03b3-f922-4146-8644-bd9889e1bf86@redhat.com>
	<87ldz9ma5b.fsf@linux.dev>
Date: Mon, 04 Nov 2024 14:34:58 +0000
Message-ID: <878qtzcbjh.fsf@camandro.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Hi Xiubo, Hi Ilya,

On Mon, Sep 30 2024, Luis Henriques wrote:
[...]
> Hi Xiubo,
>
> I know you've been busy, but I was wondering if you (or someone else) had
> a chance to have a look at this.  It's pretty easy to reproduce, and it
> has been seen in production.  Any chances of getting some more feedback on
> this fix?

It has been a while since I first reported this issue.  Taking the risk of
being "that annoying guy", I'd like to ping you again on this.  I've
managed to reproduce the issue very easily, and it's also being triggered
very frequently in production.  Any news?

Cheers,
--=20
Lu=C3=ADs

