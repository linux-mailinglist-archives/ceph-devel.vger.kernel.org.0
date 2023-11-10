Return-Path: <ceph-devel+bounces-78-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE177E7FF1
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Nov 2023 19:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3E95280F62
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Nov 2023 18:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918C138FAD;
	Fri, 10 Nov 2023 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bdss0KkF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B5C63B4
	for <ceph-devel@vger.kernel.org>; Fri, 10 Nov 2023 18:01:59 +0000 (UTC)
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BAE3A229
	for <ceph-devel@vger.kernel.org>; Fri, 10 Nov 2023 10:01:13 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-507cee17b00so2985365e87.2
        for <ceph-devel@vger.kernel.org>; Fri, 10 Nov 2023 10:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1699639248; x=1700244048; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YE6wSSy+yGYDG+b6Y+tJNP7bCqAo8fMg9L3es6MuY0k=;
        b=bdss0KkFJzNycMqBHM4Y/b3u4ZqhNkWz12G9roDjp0zr/4+AEkF+YDx+6C2grS0NJs
         p/5rBdUXC7bZIkTAJh8Bm9rtDURY1WpsjlJjkq0j90GszdBlBUmZe+Aa/zx5I+zUXJ98
         rTCpNlKdxkjx9jQEE2RUR8vOsscZiCudVr76k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699639248; x=1700244048;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YE6wSSy+yGYDG+b6Y+tJNP7bCqAo8fMg9L3es6MuY0k=;
        b=DculxlOA1qlJkAU5a5OwWYT9ADTVTIkBpiAkHUll2K+FuLdqtyAFVyCy3thoGVEmug
         TdDRj90J8v9pwelug0o/LT4Xx/7JRSHbWlWaf+qXPJolxKfTcrmAq4usLUajbZnr4j//
         De1gaRqIro6uEcwLk41NOL59TH0xYsVpHEIfFhvHxmm5y05QtX6y9ZNYJ10gP6ft0brb
         4BVsdJEAeUnUafGMrfD6LaW1/aaYg506W+K0MgdR9dsrGrJzN/ZY1+fu9VTHSOGsqzsU
         kj/1vBwBrlg8QTPR5ZtCIDLv9xOO3za9ifgQ7ptWGxpurwRaf2nYsamjqnJqkMOIBmsX
         vjxw==
X-Gm-Message-State: AOJu0YyRRywJlVaVIK0CULXWfB6KyEhQx9dKxUzFfcqEVj7VMAmMbEup
	tXYWnM2SA9xV3aIJPsYOlV9nIJx5flRZGN3RGuk7XLCr
X-Google-Smtp-Source: AGHT+IFGXKywjqipuZ9PWUqZCSwmy5oT9wLQS9dKu2hG8+T9k3AtdK6NyP9p3MARh2GChRHMrgYU4g==
X-Received: by 2002:a05:6512:124d:b0:509:4599:12d9 with SMTP id fb13-20020a056512124d00b00509459912d9mr6080731lfb.6.1699639247621;
        Fri, 10 Nov 2023 10:00:47 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id j11-20020a05651231cb00b00503258fa962sm1476974lfe.199.2023.11.10.10.00.46
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Nov 2023 10:00:47 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2c7c7544c78so16804271fa.2
        for <ceph-devel@vger.kernel.org>; Fri, 10 Nov 2023 10:00:46 -0800 (PST)
X-Received: by 2002:a05:6512:3592:b0:500:d4d9:25b5 with SMTP id
 m18-20020a056512359200b00500d4d925b5mr4178037lfr.56.1699639246516; Fri, 10
 Nov 2023 10:00:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109174044.269054-1-idryomov@gmail.com>
In-Reply-To: <20231109174044.269054-1-idryomov@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Nov 2023 10:00:29 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgZmHfx1UFOkYpwBZk7gf7hGQKeFgevYzOH269Qw0d5Ew@mail.gmail.com>
Message-ID: <CAHk-=wgZmHfx1UFOkYpwBZk7gf7hGQKeFgevYzOH269Qw0d5Ew@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 6.7-rc1
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 Nov 2023 at 09:41, Ilya Dryomov <idryomov@gmail.com> wrote:
>
> There are a few conflicts in fs/ceph/inode.c caused by a clash between
> the conversion to new timestamp accessors in VFS and logging changes in
> CephFS.  I have the resolution in for-linus-merged, it's the same as in
> linux-next.

My resolution ended up different, because I just couldn't deal with
the incorrect printouts of times, and changed the bogus occurrences of
"%lld.%ld" to "%lld.%09ld" while doing the other conflict resolutions.

Other than that I think it's just whitespace differences.

               Linus

