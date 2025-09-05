Return-Path: <ceph-devel+bounces-3525-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 45075B44C68
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 05:42:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8BFE1B2321D
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 03:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C341E258CFF;
	Fri,  5 Sep 2025 03:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="N14LEQRH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BC4221FB2
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 03:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757043713; cv=none; b=jsvn2ZC+Qa2H3RtSu/GHuGd4JQWQm14otLpYXf7TTlT4eeSa7juWNeNEWyrHRupJrvoVPvjJbJM50vf6R31xVPWeRolq5CmfI+01wwOyk5jmbY2wnoz0MbvcEOS/OHemthBe8OM3nSiLTsAuu3LYXwCqB1BClGvg1EZR9VjIxfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757043713; c=relaxed/simple;
	bh=lBiDmWrhi4c+oWflBgV0uV8GvwJWrnyIQZJXI/wC1yg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k1g/j2N61ESckNBIng/J1X7L1Ho3fHlYmDR+9uiNjk/8xyp8PJ9CJbiiGHtyE0RdECevXlMza6/OcmN9tuNUfMsy6WAou76ddoZ+jFDFrO1F8eKWJaJFcypfj+fYyyqZm8mNanVxEPP4YmEQg8YG3wH0ZPUOGXs+L7DCVWNA6vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=N14LEQRH; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afec5651966so339671566b.2
        for <ceph-devel@vger.kernel.org>; Thu, 04 Sep 2025 20:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1757043710; x=1757648510; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBiDmWrhi4c+oWflBgV0uV8GvwJWrnyIQZJXI/wC1yg=;
        b=N14LEQRHhqmtODriSkhCJ9GNNsq7QDmuWirt+Jj2YpibWqNSdosfmX5WTenqVnRBm8
         ae+06cevl1ROQCmbYivja9C7dPvA+BT7CMFbfKm0rc9s7lzwfnGjWAN6Z7uJLdSmLMfo
         9pKl7QKcPi4maJNkxBBuj92vsq5yIQpO05BOKT333W6w535VuKr8d/xnWCQbp302IDrh
         OTNbYJ8fKgn0eca6U+IC65hGyOqogrNdKsn70jZ9pcMHTa6r3EQ5tiSjB+AmZ0vrxjx0
         pYgVd0i6hnvqKsjcImbP1EOoLt9ugtAkrGoMx8HdOYTZ4Hi7jWLihMnJcbxlFdb51ekd
         6r6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757043710; x=1757648510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lBiDmWrhi4c+oWflBgV0uV8GvwJWrnyIQZJXI/wC1yg=;
        b=EyRvUqvwm+YlD4SmwmhQ2AhqUwd6cGgRFmR16gbu0hNnwNemjCjZplJRQfphOHmeA6
         apDIlVGsHCXLviiydAJdzVpImteCAcP7sv1iZZVSJ18A06tMdWyaLfzblHlr7ITvtgdn
         8rgSrv4K7JiEYZz9aW75wspq1nrJOVI+BN/GUF22ZvgM1n5mGSTHcFAe7wf+/H5heeEI
         C2L9i9EyVxrONmA+gy2OWP7Jk/vRRPP0MJ8mu1fq48q9x3e8wz7h8zmVy1blRxtju08e
         841PXRQuEybeieh3EOji3V2RIhX7ae31/h3PzwLsnR7kfTceojJW0EM92c/DiWolwFCJ
         lKcg==
X-Forwarded-Encrypted: i=1; AJvYcCUPp+BItd7AzWzljJzMzSOhYHgY6ET10aRzgDrsspwVLoKpgTdMzD8qz9BRjd4etWgXMF8C74e1fkOk@vger.kernel.org
X-Gm-Message-State: AOJu0YxRXjUKoGZxm/8j2L4U2DU/ZIEAhmHbwzD5SsUKcTSHnkC1clnx
	YZOkgwDk1DzwNJzx0qWM67BOYF8f/M6nha9pJo3WiUGzruhYwTOX6fl7KjmsQ0hjntMAe8aygFq
	EQ9D3eBJ/p450knr+L9M1/mYWK2Jqz5sJvPWRInoh6g==
X-Gm-Gg: ASbGncvmtGLGBX/yi13WMFFKW7BfMMSoUlluS6BNCKlaBJIHc6AYdDQpf7AfPHFfZtz
	fFjB6wIO8pBmxmJqDMXvxc1honDjNAawh4R7mxZO9arNjmXQSrzFTcCYD7dKlijKcw2zEjua0WV
	K6S6ucHiUVdhxSfj9PSbKaXUWDuA0oEnmcIbrerlFNSiVaXW6f+kgdkSN7Y9anb3OUT8NGpHWgL
	sO+cjNfPWgFf28/qDRHV2LFd1GlI6jgph1p5o9YSEF47A==
X-Google-Smtp-Source: AGHT+IHov3qNZs7G3VUo2wWHrIzOMamlj6Sw7x9E1E/umEdIxDjNRb8LL8tMtoVXrxFeEbOX//exQM1lQ8IYRyF2xg0=
X-Received: by 2002:a17:907:3c8d:b0:b04:6338:c94d with SMTP id
 a640c23a62f3a-b04633912b1mr929171166b.12.1757043709612; Thu, 04 Sep 2025
 20:41:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827181708.314248-1-max.kellermann@ionos.com>
 <791306ab6884aa732c58ccabd9b89e3fd92d2cb0.camel@ibm.com> <CAOi1vP_pCbVJFG4DqLWGmc6tfzcHvOADt75rryEyaMjtuggcUA@mail.gmail.com>
 <9af154da6bc21654135631d1b5040dcdb97d9e3f.camel@ibm.com> <CAKPOu+8Eae6nXWPxV+BGLBVNwSu5dFEtbmo3geZi+uprkisMbg@mail.gmail.com>
 <25a072e4691ec1ec56149c7266825cee4f82dee3.camel@ibm.com>
In-Reply-To: <25a072e4691ec1ec56149c7266825cee4f82dee3.camel@ibm.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Fri, 5 Sep 2025 05:41:38 +0200
X-Gm-Features: Ac12FXyjYfRCbJFUsaW3YVtT6St7moB3w1CuRj_GKqrFlnMvkWd3J77m_afuHp0
Message-ID: <CAKPOu+9MLQ5rH-eQ6SuiXTzFCEhmaZ9s-nKKQ4vpUCyvc9ho8g@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/addr: always call ceph_shift_unused_folios_left()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, Alex Markuze <amarkuze@redhat.com>, 
	"idryomov@gmail.com" <idryomov@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 11:43=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
> By applying the patch [1], enabling CONFIG_DEBUG_VM, and returning -E2BIG=
 from
> ceph_check_page_before_write(), I was able to reproduce this warning:

Thanks, I'm glad you could verify the bug and my fix. In case this
wasn't clear: you saw just a warning, but this is usually a kernel
crash due to NULL pointer dereference. If you only got a warning but
no crash, it means your test VM does not use transparent huge pages
(no huge_zero_folio allocated yet). In a real workload, the kernel
would have crashed.

