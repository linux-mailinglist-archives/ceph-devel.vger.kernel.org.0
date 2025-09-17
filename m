Return-Path: <ceph-devel+bounces-3668-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66956B81EB6
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 23:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 898D1188572C
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 21:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08862D1F44;
	Wed, 17 Sep 2025 21:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="iSOT//CT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C69119F40A
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 21:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758143979; cv=none; b=XEvcAc4Zc0v0hh5V5upzVUaTxmOJn2ascDtrRB8vE3IoW9st9oMV9DBFSPNvUepvAWaCkN0X+bl3+RNCyAEW8W58diW86iHt7bbbEDcVtvOivFYUDpJO4QAaUGMIWFjjaU2Ppa7pITT1ZUDIh4/aJihN7QKDmnXSvbLXc9gga54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758143979; c=relaxed/simple;
	bh=9qcl2R03KtNq+UmhO5wJsFOtjw5gkCqDNII6KYbvzuE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g3YNJlhUUFnA+SIR+Xgg9Uh7TvXXQRZT9QotSXNNqETAdGMu2CgvegNUedCLs2u7bJC/o/YThH7awfJITEPr/ocKiWn2jbcPuKZa6xq6u/X/Xn+SN4NAxgHNmQz/531bLcmnuwnaqjTDbjH7FJwQUcgjIH8r65XFzn2cPedPzvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=iSOT//CT; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b07c28f390eso43885066b.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 14:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758143975; x=1758748775; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=djRf9vFpcYD+NIrGmvtw89De7IcIWa6+q7heNKofahc=;
        b=iSOT//CTfPGeVT+tehRDAAYmHzoYb9TdOdaGbh1rKK7J8IUw9FTXVRJ2Z2MfBbttgf
         TOFJLyfrT+FWGvZZubPkYpoW+iwQagvc6eJTp4cuDEf0BfCrt6kKt4gAEJ1i2OPeAbI9
         L1ugMKfNCY7REiTANx8AisJIFbzXlwDbdfoKCdl2aom8a3rPm2y98yUsXy8bI1JapNpw
         0CNY6ndahWo4p/Rg1pla3Uh3K6UMswAj22vmwXnigN83rgifULYGk111W1LmvDz5ZLJs
         WoWm3PXlVoIaVfDeUmXlPb0nl+tQKxOQkm2/2VqMuQM2BaYxpWvjpFH9XLuLhEb4/BWb
         eGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758143975; x=1758748775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djRf9vFpcYD+NIrGmvtw89De7IcIWa6+q7heNKofahc=;
        b=iRCeOEVi+AOq/b4+wScLB7MTZz2tkQRi7QhEi0WaOVM4xlnD+jEc+9GR5idbUUBgpI
         vUUrlSWTKSxkxkdQtGKL1A52bxi4TCAmDlLyeEEqNNJwib8dClteNcLUR+41uuA1YRJL
         3YHa2+AwL2SI1numA7g2uGMdelfIKq9b/TMzPs6DWVerO+fw2e+gI05oipagFeem66TD
         GXUAO6a325MxZ64hC0lHsxGoT9K3IvFPhQCD5rXLtkgpu3g/Fd3e3EBjOeIRgaZZxSUB
         apXbX4kU9w9RIJFaE+2sOQFfEMDVy3ZLtMtRsXq9ogDEJCiPy75LTutlzm//URCPYFMf
         xsRw==
X-Forwarded-Encrypted: i=1; AJvYcCWyMeO5pI/9dMCbvffPLBkFXX97Kcra3E64OQIimOs3BOByX0TEqgWyimj6TcVW8RkWi69xK66k3jPj@vger.kernel.org
X-Gm-Message-State: AOJu0YxU5NckHGkeIs1E4c+qxDFn9+RuIZvnlIiJiCOx5CIn/82DZBdD
	PeiY1A1fBJdn5DqUovfT/F2LzZoPp+PMpR48iq40ccTrNbiy3y3z8kr5ewKQ8o+Gb4hYxjq/c9W
	L/gMqLjg0ZjKNhTnIkJEOiYfNKsovL0RIuebF9WN/uA==
X-Gm-Gg: ASbGnct7B/53CvvYABvg/tSgcPZ/FUbV9NwjVqxiRlONJETFdpvjOupgssC4O8ZJ1Rx
	GHVez61DcL2dBUB0oo/+CIumL6MY479ODZq3QT2sFR/Wec2AiklX6BKqip7jr17PIB03c+k159V
	ido7JDkvVObsWjD9SrEqNaylSttB5LLHtdcBWA0wvcZLVVFNxXOOF5ajVlZYOQ8oU7xCYeaQqct
	hsZugbV8k1aszfbIhWXMgdzMruyTUjeDKDHh7nL7IEizFWbKFO1hvk=
X-Google-Smtp-Source: AGHT+IFx0UdBWSFzYZQCS0rHKafbSNkZSpgCULmd3CeOoP1qT5yHjsnFa6vko92RxDrAUE/s9j8jFsO1c8h9Tuwiqu4=
X-Received: by 2002:a17:907:3f20:b0:b04:6858:13ce with SMTP id
 a640c23a62f3a-b1bbd49ad36mr433982366b.38.1758143975487; Wed, 17 Sep 2025
 14:19:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV> <CAKPOu+8wLezQY05ZLSd4P2OySe7qqE7CTHzYG6pobpt=xV--Jg@mail.gmail.com>
 <20250917211009.GE39973@ZenIV>
In-Reply-To: <20250917211009.GE39973@ZenIV>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 23:19:23 +0200
X-Gm-Features: AS18NWBuDJyrihrXYWVEdB4-Fs__rxwIrvhTfFiInfF4MuBKEbv8_ShZGxuvgzQ
Message-ID: <CAKPOu+-yOH6yzPEw1rayR1thO0OdPYCRL-CWkRTp9YFuHuRr9A@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 11:10=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> > Each filesystem (struct ceph_fs_client) has its own inode_wq.
>
> Yes, but
>          if (llist_add(&ci->async_llist, &delayed_ceph_iput_list))
>                  schedule_delayed_work(&delayed_ceph_iput_work, 1);
> won't have anything to do with that.

Mateusz did not mention that the list must be flushed on umount, but
that's what "incomplete sketch" means.

(The patch I submitted uses inode_wq, but that's a different thread.)

