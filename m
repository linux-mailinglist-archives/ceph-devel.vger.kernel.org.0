Return-Path: <ceph-devel+bounces-2423-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC6EA085C4
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2025 04:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EBAF169474
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2025 03:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496831FECA5;
	Fri, 10 Jan 2025 03:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMvtmix4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7211E2607
	for <ceph-devel@vger.kernel.org>; Fri, 10 Jan 2025 03:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736478384; cv=none; b=brLcwkvPZBdpVn8pDiONbhGHi7S2fxta3ouJnK4Y4FvyYI0uu4Yqr0u+hErBqbMbEjdbdAZin1D4qzSibUGhOspfb70UfOszJhvj4b2ySEG3JTjyrO1vfLrlYf/vuXzSkGWmFS4ZTrqDoSS29iNLKETia+yRpI98tEQdJS5RqQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736478384; c=relaxed/simple;
	bh=eO9qA3/8ifU3K1qAWG9+/jWM0J19EBHyfEdTCwZPx8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=faLXYTKbTkWSUutpxek6WmVwpOOWb7XNMYkeM8xtrwZZmvcy0+pYl7ettEkwqSDZWt3YFTOkyIN71ZyDASv6BIoLT86Wq81tX/LvnDsgau4C4YYpuMZ1QtMl4/qdq0GpkWu0p1ZBkxCglbaR67qWDfNNR8pvdoZIqn1cky2XKdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMvtmix4; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d90a5581fcso2548108a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jan 2025 19:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1736478379; x=1737083179; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NT3GMHnGMUPgyBvIrXX2eIZQS9LIQ7g/foVqlCeiI5w=;
        b=HMvtmix4yr0JDHm0wOOPxDdTw2fKMmgIYzGdTYk7lnJT/4sfZdw2iz6T5NILC0VFGF
         H4kKdPkYoVR0Xs41rq0tyefunvhAPXGPo9KLVjChNA5OoctLv8aPF6Bt8MW8wMLG5gjC
         6M1bJmDjQ6Dk63z2WMua8kKSK0udm1xbgP/+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736478379; x=1737083179;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NT3GMHnGMUPgyBvIrXX2eIZQS9LIQ7g/foVqlCeiI5w=;
        b=aH+n6wAHkt8BedzcIMo8xMzHEJIp6ivLRsvuH2oDunZ4SGgtdTHxun78APQB1jis0O
         frSPzFXJS5ATN32zOQlpWQWgnPsrLpeaR//MHO/rqV2vNNnLzYZv5O7BrjenCzdN2GRC
         TcNXIgINFX1u3FgCYhdWKtA0xTlIQ7d7sxha8sxskW1A3LMN8XDjEDeS7v8ilEA05DLh
         MEot5efnHa07OngwNK10UT98ASBpnvFkxNFcui15ocg9Mq3KDMTU5qYYUY3TUWuWoYBo
         Wt59MsOH7mUlzaOedCpPygYnbtzAb2LWV/4ayNKTdURlGoLB6Qoek3iQEK0PR0Kh3W6U
         AykA==
X-Forwarded-Encrypted: i=1; AJvYcCUmCuwj9mFcWwCweu91Z4EskfvJ9cj9PhthuuPjmplafNMuAkqXY5KJ06BfqISyM1tRv/z2SMkOwlkj@vger.kernel.org
X-Gm-Message-State: AOJu0YwSNG08Y7narqaIIaOivFfCCmVlpEg5bvz0Ke5V8zNy10f6XVwb
	l3XDSlViPbXNuMj8eYCJ45ryj+YcYjvztl2ZYPP4d5RBjTpuU/MtAjUZVmlOmiAx6JiPAUcQlvQ
	qYYb7TA==
X-Gm-Gg: ASbGnctvDgvPhYj+E85j1DWHBbEaPRLC30KJsCA2+sEgkRpZ1abKqUD3mqjjM+kJYat
	6LYm59kSJbYdCB0y9Nzx1QBCH4prS7prirfbT0tqGVpHbiQtIc4GeipeNuC5F3FPsObbDC6/W8t
	cM5YQXRdVb+/wIhWCiPPjZpDXecOXGvLlfXu/NhGnaC/MOElu2eWP//0vV/48Xuqyl5+aQio3xg
	IX+Wx/i1tANm7+0b4EO2355SmnNqp7K/nzH4aCZ+Dv9i0scndbJRubmLMwwjUxpdrwGErtSajP4
	qTVNYin4s+VlHfqBt6ROXeqsJS8fOLc=
X-Google-Smtp-Source: AGHT+IGFGCsuBpMXQIr0QI/p4O3daX2FjloAp04N6QxAknbBzsxjn+aejjM+JBAzETbHqQTKaduMGg==
X-Received: by 2002:a05:6402:3585:b0:5cf:e66f:678d with SMTP id 4fb4d7f45d1cf-5d972e6f913mr8084853a12.28.1736478379513;
        Thu, 09 Jan 2025 19:06:19 -0800 (PST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99046d82dsm1121407a12.63.2025.01.09.19.06.17
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 19:06:18 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3d0205bd5so2226161a12.3
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jan 2025 19:06:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV/3iCYLJaPTg3GW4xPY8EMsaT/7fr03cGcqqQuC9Omp8CEVdy+uMRI+KvocNQXmEw2hWpPhi0vdW+L@vger.kernel.org
X-Received: by 2002:a17:906:f58c:b0:aab:740f:e467 with SMTP id
 a640c23a62f3a-ab2ab67061amr690971166b.8.1736478377190; Thu, 09 Jan 2025
 19:06:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250110023854.GS1977892@ZenIV> <20250110024303.4157645-1-viro@zeniv.linux.org.uk>
 <20250110024303.4157645-19-viro@zeniv.linux.org.uk>
In-Reply-To: <20250110024303.4157645-19-viro@zeniv.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Jan 2025 19:06:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=whbsqyPw2t=OaCgiNKSSDs48hXm7fdGnTbDqTg7KTY-JQ@mail.gmail.com>
X-Gm-Features: AbW1kvYZQhGLGE_BMmhRgYKnvI869LDYbaAYYJtKtzXM8cY35G-c_oMO0L1sNfg
Message-ID: <CAHk-=whbsqyPw2t=OaCgiNKSSDs48hXm7fdGnTbDqTg7KTY-JQ@mail.gmail.com>
Subject: Re: [PATCH 19/20] orangefs_d_revalidate(): use stable parent inode
 and name passed by caller
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, agruenba@redhat.com, amir73il@gmail.com, 
	brauner@kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com, 
	hubcap@omnibond.com, jack@suse.cz, krisman@kernel.org, 
	linux-nfs@vger.kernel.org, miklos@szeredi.hu
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 Jan 2025 at 18:45, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> ->d_name use is a UAF.

.. let's change "is a UAF" to "can be a potential UAF" in that sentence, ok?

The way you phrase it, it sounds like it's an acute problem, rather
than a "nobody has ever seen it in practice, but in theory with just
the right patterns and memory pressure".

Anyway, apart from this (and similar wording in one or two others,
iirc) ack on all the patches up until the last one. I'll write a
separate note for that one.

          Linus

