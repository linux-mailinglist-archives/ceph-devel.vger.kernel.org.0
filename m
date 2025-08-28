Return-Path: <ceph-devel+bounces-3492-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B25CB3ACCD
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 23:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A0DE3B13E9
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 21:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41AD12BE7AC;
	Thu, 28 Aug 2025 21:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="RhyNmpVI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7332BEC2F
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756417068; cv=none; b=BHmPc9rU9qhNx5slSGEr/8VA529IAreo9IoSG7Lnm290LMqzC1DEk06/dMRejzhH63wK9hZwZVdlCfOm9TNYotJSV3s2AK3abnw4bAKQerj4CgvU5mILygEMMSyz9lPtn/7X/fOUGbaCRvWqDWGeiiAFRbnH8p+as+m454ki3vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756417068; c=relaxed/simple;
	bh=n1Iskaazac3NoZPGkz+7My9kwW7skAilgI6o4L9Vgnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ttrt3zzS8zGH1UCmv4XmJG3FsXSDNlo2t0dIkndFb6Y10sZ+KX5wlse68Dxz40s8wNutU2EoO987yy6Q7cZDo/IdODTRCavEkkcdbUZuCBz02xeeEdLiBg7uX8BA4IPwMB9B6shS/cCFhM1QpRKrh7w715gVhV4KHCmYIA0k+WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=RhyNmpVI; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afcb732eee6so239195166b.0
        for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 14:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756417064; x=1757021864; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1Iskaazac3NoZPGkz+7My9kwW7skAilgI6o4L9Vgnc=;
        b=RhyNmpVItT1OhNYL7ez5mf2wVjwJviFUcU9wZ75GkM3NgwH/gyp36LLmMZo7MapCuH
         ajjKu8yilGN19VEnzO0u67rEKPIaZ77VR0invggLiO6dM9/97upYxqaOP7v8hBYQjP3f
         2ILwByZ/gWdGFhZKuBZeUJtXVA4w8erA8purFsMNVWPxhx2fNX+A3GC4igSJU0PRPieF
         +2O08//x4HIfkjBGTDG4FUH+HWdYzDXt9tzKyXhXIUFusdN3kwLQGVK3RfLihQiQAIms
         kAug2cD7dY/apy/7VBK+yyFbjiey2eF2it8v4pGod/VCh8Glh2RViPyHbyx63pKkU1FY
         RXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756417064; x=1757021864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n1Iskaazac3NoZPGkz+7My9kwW7skAilgI6o4L9Vgnc=;
        b=b7Pjk7UjUxrt/D32ZB8WX1boWuBmTQ6PhIDj/rKKct6M/NgyCAHD84tqwX6o8QB9QY
         bayrvpnEyIrirea8LkiqXcxCwO0H2oT4xG77S7a/DJ2shsPiI9vyMM2vvforgLTC8pBg
         YzrUZjr/7egThkja5wkAsIqaZc8Qk0EJ+NBITW+98OwULNuH3Q8g4dOScXmb/39vTv+f
         U85X6nA0XA1wBxbhbJD51lByOMfcocNa8pfadtFyKQoKsb4csxjpl/g2NngudC7i1kOO
         NMAkEnh6QGYG2CnRIOcBVaUg42rdh1IbEr0gUeGCYmahqnnPTcfvbfZpSLvd3rXh17Oh
         nsIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvAJfm3HAwwF1qYY51kMz2ShtPeDK9TbfHu5WkYiPcoQMbR1Ak3yYFS3fSK+e8TjGeJa2QGxYtDVmC@vger.kernel.org
X-Gm-Message-State: AOJu0YztZ68qoVqMy3PubiHbK11LHQD4XMGwqAzNNkc//hf/4VVNWQKt
	+biGaeXHIEFCYLJ8odGFKAIk2HsQBcJ6mJqjmM7N2FroC8NeXcimOb6Ip/igvzKFRp3Qc4S0hJz
	MgfwEQcqm3tJcV6BwyNkyi0b/Wuz8HViSLYmXapvQsA==
X-Gm-Gg: ASbGnctAmF20Fnuq9WaZrYWOdBIU/AxGXfl4uqd2XgapSohjhrqt8S7vq1fs8lNmUHj
	QFgdmNeUM6FLoGYg9KoAkyX9SfNRlSoqErWh7ycUZrVXzYJ/pNbfhfh7km16dYoEjlGOepjrkU8
	/b+hLV/lnn4RElMAvJgHTMj00oJEc2w9QNz/iBkDMMl0eAV/aAPiLfltuklGkcHx0PDMGAjPlAK
	hdpRwnhroYpTjb40Ujd0BgehYYKJ0NuKYs=
X-Google-Smtp-Source: AGHT+IFfEl25/8Tm5gw/JLM0ZDgYcAi2d4dD+qZMY4CzFwIK6dSzfOXCNpHt0UxEnrMw1FBkvWvevVG3jtuIeVGeqnY=
X-Received: by 2002:a17:906:c4a:b0:afe:7aee:8fb8 with SMTP id
 a640c23a62f3a-afe7aee92abmr1189760266b.65.1756417064090; Thu, 28 Aug 2025
 14:37:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827181708.314248-1-max.kellermann@ionos.com>
 <791306ab6884aa732c58ccabd9b89e3fd92d2cb0.camel@ibm.com> <CAOi1vP_pCbVJFG4DqLWGmc6tfzcHvOADt75rryEyaMjtuggcUA@mail.gmail.com>
 <9af154da6bc21654135631d1b5040dcdb97d9e3f.camel@ibm.com>
In-Reply-To: <9af154da6bc21654135631d1b5040dcdb97d9e3f.camel@ibm.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Aug 2025 23:37:33 +0200
X-Gm-Features: Ac12FXyg1woZdAkE364W7NQ-KL_VSHZexBcxE-tpmU4ZEA0rdG6e-J0x3eIcJTs
Message-ID: <CAKPOu+8Eae6nXWPxV+BGLBVNwSu5dFEtbmo3geZi+uprkisMbg@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/addr: always call ceph_shift_unused_folios_left()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "idryomov@gmail.com" <idryomov@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Xiubo Li <xiubli@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025 at 9:08=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
> And which practical step of actions do you see to repeat and reproduce it=
? :)

Apply the patch in the link. Did you read that thread/patch?

