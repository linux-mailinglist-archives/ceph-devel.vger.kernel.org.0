Return-Path: <ceph-devel+bounces-518-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EBC382A098
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jan 2024 19:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8D5E281BB8
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jan 2024 18:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8067F4D58A;
	Wed, 10 Jan 2024 18:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PcwF3hhK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8DC4D594
	for <ceph-devel@vger.kernel.org>; Wed, 10 Jan 2024 18:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-557ad92cabbso3994332a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 10 Jan 2024 10:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1704913131; x=1705517931; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m3UJsqaOgk5eE2VQnILkdg8C0bn7x8fx0mLavVcEL4o=;
        b=PcwF3hhKFHjDfnj9tIz6+VWk2JeQO4V6Rwd3VQzrMiYCX7mIwfkeLev7mmGUbRzXnw
         wWRsIQyIM0/unA/ahqF2Qzj241kMbvgAf+jZ4eLzUVM82DEJ03W9bGuO0ymrZ1ZdDitO
         moOYAz2Sc12HtLDCGoVY1vHwu9uLJSn+J1y68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704913131; x=1705517931;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3UJsqaOgk5eE2VQnILkdg8C0bn7x8fx0mLavVcEL4o=;
        b=guf/q+a9bsYbNnnEB/f32lkR4eV+jF5nHHlGO+qqseT2QPd9thofua7pUayBXndFRg
         DZ1ZCGuhR4sRtnUJ4LHF35Dj5nyoZ931fll5RwUtsr+TQCwokVk6btU5fhRrEGx7ExYN
         U4p+ABRZFx4nd6AuZda8+JmFDu3iilEkHPZmDCbYc4E34CTZZMu4UN4uCHhArvEZXF3f
         jsiOntSnQ3SjMj1nMvybuD5463otlDx87NtP3WSZwzG2GXSwkKQh5/TcaFTcjQKLivTq
         zCUYodWJPLXBRk+A4i+z77Y0pUYCUth1HAiexBuYWCy+4QLgmK+JQhkOi+7EMhEM6jlZ
         5BiQ==
X-Gm-Message-State: AOJu0Yw9pnoJ9uNAGakZ3IkqHxFP0QepWtuaUwTDWBtD3rIO6XGhY1nM
	YyBvdZfeiirBxAVOjG1q2ZGYnpM1zUbzrnHBHXe/CrYxcDFS57cR
X-Google-Smtp-Source: AGHT+IHEs1aLilu6H/5LsZe+y1g7s90ZNkI289kuMYJMtEGa/z5797CLvmu09adeadY6Gcz0vjOWqQ==
X-Received: by 2002:a17:906:f58b:b0:a28:b659:cc87 with SMTP id cm11-20020a170906f58b00b00a28b659cc87mr743406ejd.123.1704913131139;
        Wed, 10 Jan 2024 10:58:51 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id hg7-20020a170906f34700b00a28a66028bcsm2362724ejb.91.2024.01.10.10.58.50
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 10:58:50 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a293f2280c7so524629966b.1
        for <ceph-devel@vger.kernel.org>; Wed, 10 Jan 2024 10:58:50 -0800 (PST)
X-Received: by 2002:a7b:cb45:0:b0:40e:4ada:b377 with SMTP id
 v5-20020a7bcb45000000b0040e4adab377mr402184wmj.62.1704912744493; Wed, 10 Jan
 2024 10:52:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZZ4fyY4r3rqgZL+4@xpf.sh.intel.com> <CAHk-=wgJz36ZE66_8gXjP_TofkkugXBZEpTr_Dtc_JANsH1SEw@mail.gmail.com>
 <1843374.1703172614@warthog.procyon.org.uk> <20231223172858.GI201037@kernel.org>
 <2592945.1703376169@warthog.procyon.org.uk> <1694631.1704881668@warthog.procyon.org.uk>
 <ZZ56MMinZLrmF9Z+@xpf.sh.intel.com> <1784441.1704907412@warthog.procyon.org.uk>
In-Reply-To: <1784441.1704907412@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Jan 2024 10:52:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiyG8BKKZmU7CDHC8+rmvBndrqNSgLV6LtuqN8W_gL3hA@mail.gmail.com>
Message-ID: <CAHk-=wiyG8BKKZmU7CDHC8+rmvBndrqNSgLV6LtuqN8W_gL3hA@mail.gmail.com>
Subject: Re: [PATCH] keys, dns: Fix missing size check of V1 server-list header
To: David Howells <dhowells@redhat.com>
Cc: Pengfei Xu <pengfei.xu@intel.com>, eadavis@qq.com, Simon Horman <horms@kernel.org>, 
	Markus Suvanto <markus.suvanto@gmail.com>, Jeffrey E Altman <jaltman@auristor.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Wang Lei <wang840925@gmail.com>, 
	Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	linux-afs@lists.infradead.org, keyrings@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	heng.su@intel.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Jan 2024 at 09:23, David Howells <dhowells@redhat.com> wrote:
>
> Meh.  Does the attached fix it for you?

Bah. Obvious fix is obvious.

Mind sending it as a proper patch with sign-off etc, and we'll get
this fixed and marked for stable.

           Linus

