Return-Path: <ceph-devel+bounces-4160-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39384CA642B
	for <lists+ceph-devel@lfdr.de>; Fri, 05 Dec 2025 07:50:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C575C30341E9
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Dec 2025 06:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C7521D3E6;
	Fri,  5 Dec 2025 06:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSJH8qIO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16C1217722
	for <ceph-devel@vger.kernel.org>; Fri,  5 Dec 2025 06:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764917446; cv=none; b=g4WTquqg42Ou/gVxbFBhhDy92sHnl8Q3gkpiVZt5RimxvTe2vjoXeVa5jCD0QR7kULQlp1wq6v1oG3iBdlZ6iZQ/Kvd5W41KQkPxklWQLKwyJwAPzF0gKCJlNScno3uj92cFNWoZm0uyPx0J8HVbyX0keVYaYl7/1oJg/8AWp20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764917446; c=relaxed/simple;
	bh=79no1teS7gNeNFbVpURDq/0eF90Tq421frNJ+bKihHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AvoYNIh8YYrxKIQqW/j2chctVP42bYLjjHOwGPufwORgJrR9zoXUQnBNS30o0Hr39V0UfUSZPiKPXnvIwL/L9LA28XPz2baC2RZM4CoHyETHrNGzihyI1/rNtca62HwsAsthrgMsHefwUJBd+xx5Jup5daRJO6zJ1NDFz+HKpBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSJH8qIO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A94FC4CEF1;
	Fri,  5 Dec 2025 06:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764917446;
	bh=79no1teS7gNeNFbVpURDq/0eF90Tq421frNJ+bKihHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YSJH8qIOL8xjDB/hFqUpa0ozbnt5PlamNlLzcgqqNd8zkJAcOFBHfr3puOXLAIgN3
	 esxP3Z2Pwtiyw2WdQ25rAmg+8JJu2l2WVQO1TqLBK7kV9TNnCoq2kmK/NCQgIhJRfB
	 huwUCI2fe/taEiUwLkP8HusZY4P4ZtyQwGsIydWUAS9cCBGqcLPMNQq1le82q+r26Q
	 myOZ54DdHgG28VaHseoJGTfu/kJJofvMmUAf/NG5njPMVCRyi1qKnCAMBi4VOpSJM3
	 HVElkKuqqE6ImqHBNkbT6D3VOod6IYdwLSdD1MCB0ZPbTbnq7Dq3B9OHIAMeLhjFPP
	 hL7f1FPmo8uGw==
Date: Thu, 4 Dec 2025 22:48:52 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: stop selecting CRYPTO and CRYPTO_AES
Message-ID: <20251205064852.GB26371@sol>
References: <20251204061118.498220-1-ebiggers@kernel.org>
 <CAOi1vP8nTeNinKN-SfRKeHRaH7c-Zci4TnUbqcmmftWWpc25dw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP8nTeNinKN-SfRKeHRaH7c-Zci4TnUbqcmmftWWpc25dw@mail.gmail.com>

On Thu, Dec 04, 2025 at 05:10:28PM +0100, Ilya Dryomov wrote:
> On Thu, Dec 4, 2025 at 7:13 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > None of the CEPH_FS code directly requires CRYPTO or CRYPTO_AES.  These
> > options do get selected indirectly anyway via CEPH_LIB, which does need
> > them, but there is no need for CEPH_FS to select them too.
> 
> Hi Eric,
> 
> I think the same goes for CRC32.  Would you mind covering it in your
> patch?

Good catch, I'll add that.  Thanks.

- Eric

