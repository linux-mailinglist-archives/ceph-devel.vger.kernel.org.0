Return-Path: <ceph-devel+bounces-2931-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC031A612C4
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 14:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3C82881049
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 13:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEBE1FF7D7;
	Fri, 14 Mar 2025 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWXLHZQa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54F1FF1CF
	for <ceph-devel@vger.kernel.org>; Fri, 14 Mar 2025 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741959280; cv=none; b=Cbm8arW5wmRhUyg11qvdDBy8Oyr0fAzXoM4FkLON2X9N3lAa61qWfmrdJRZBGufDBTdB6sM4g8ffEF4V+HY1VyJ5CnpbAeYhcSlSZr2w4qyqxJVo9fwSdas/Rr4K1k476uh5+ngdc6cO0x47smLHovxIcg9l7IiaDAsH/Dj/qMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741959280; c=relaxed/simple;
	bh=zKcDg/WVrHAClYrz65J+YuN4a7ClCK7nzNBjU72ACuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bUFyVApeCJNncXQuXJKCfIXzeooQqkCFhFqC/gm/QEIOpJxR+TgTuJcw+YES1UgvU+WTXbXl2fRvke1EUsbtTD9U+P7CZGLiwO9V1aPW/0YdPmQiCmspQs+AAG+GlPI4s5H64gHmhtlQraJdwkNyy4MIz9ygTIpdVUXmoNrrk+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LWXLHZQa; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ff69365e1dso3155422a91.3
        for <ceph-devel@vger.kernel.org>; Fri, 14 Mar 2025 06:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741959278; x=1742564078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xc6rHCNInQGavHtVfOb32HqAvvM7TuqS+tELgcEWg2o=;
        b=LWXLHZQaf9nFh+sJtLv1tWbHlrD1vnRVmFZfeBqMwW4n61h3HZh47GicdfjFTjiJ/s
         drHyhTTT2h4N8+ZK2zRo4LAB3Bp61VpZezhP+egAobKViOsGMYp0oA787XuGFOI/Xtr+
         OpRlLc3pr4Lu2ZvFf9Tiu2r8aWNmeMzTCqH934kxooMPEVBKRBQsnfWaBw46Fgl8GxJp
         lPPlwrwfOW9DDRuBmCL6TRD1bTodwl92S+uUooYlGYUBK/mlwlx3p7BNzNcJ1BeAtwkm
         J9OSYr4zvlu0YK2bMv6dQfjigpDA7XfFuUd4VByPdcxaS02shEjd6KNkTi9HtNlxv5Xf
         uNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741959278; x=1742564078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xc6rHCNInQGavHtVfOb32HqAvvM7TuqS+tELgcEWg2o=;
        b=vPxZJ94oVt3r2NRXWQnfCKaqjCmzV67ylLXVL++BRfsBsgG1V38JyobHqCvFQJWe9x
         JxLZzII0J/b49w/BJz6avX8//5sFO0YaGNIwHrS2dZuyhMHikGTiOOTHpvp5ql8AmrAO
         665d5PbhtDfkIh4Vqgtw7oKRzIGyNuwfVGsLpnBFr7EWJAZnKJU2Xh52WPTGfC5gnWvV
         7lkFap//dI5CfU3SE8NHA9QimsljUDbzitIkESDgQWJA1u1hWXACCtlKsawt0WPBY2O4
         DYFnJ7E+f1ADqVI19w6aziYky7Lh4FA4bb1TOxG2PLfZf6ePrmN1Af7ZWX45DcafsyRw
         1UUw==
X-Forwarded-Encrypted: i=1; AJvYcCUH9QNd12WvSaue/8VYSAL2cI8aJoICIR4ACbBTkOfMQGdgUcWGExWyOnqG4dyg0ecEHLY/0yPLNzF8@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8wf/yq3GHaVzEl6gzmCTJCq+9a8NmR9GfMEBpWoHeOO3vOaFY
	k4fYTYCd32mbaEldOwFO/T1xMGg2xclXOiYSknxBZGk4fxtkGslQmDp8ljxi+VwkMTRc6OCylQ+
	dIM2oY/NhSO+aFSyq5H0cq4F4NSsmomMl
X-Gm-Gg: ASbGncsC6BlTszPZmsEfUNoHDH8F4yJ6aw9sbEjxQWZ/+RmcF3AHxoJvzqu6L1j/c1L
	zdY5mEjwIgemankt5/eHRT3ePWOnQc+hKpVNoQecQTn6kOXi9xDXSulhBTZlPBZYDpKLERV1b1s
	yf4NzCEhu+oidk/cmTEgbtAV7teA==
X-Google-Smtp-Source: AGHT+IEhaqObea5B/BaVFrHqzZXEV7dafAa3dewu/TImZxhrseJSk4OCwzDHCRFKa2zxeUmHSRY32vSzhYhkUJL80qw=
X-Received: by 2002:a17:90b:254d:b0:2f9:cf97:56ac with SMTP id
 98e67ed59e1d1-30151afbc79mr4147208a91.0.1741959278489; Fri, 14 Mar 2025
 06:34:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1722309.1741949485@warthog.procyon.org.uk>
In-Reply-To: <1722309.1741949485@warthog.procyon.org.uk>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 14 Mar 2025 14:34:27 +0100
X-Gm-Features: AQ5f1JqAAROwGISt6-qN0SZokATfDizITR-CRCtPXw4DR5rCVmQPjEu9syst8B0
Message-ID: <CAOi1vP-0yKFKKhy9i2Zmd5coZ59vMMNu2upkZLWvR2sgxWafAw@mail.gmail.com>
Subject: Re: What are the I/O boundaries for read/write to a ceph object?
To: David Howells <dhowells@redhat.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, Alex Markuze <amarkuze@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2025 at 11:51=E2=80=AFAM David Howells <dhowells@redhat.com=
> wrote:
>
> Hi Viacheslav, Alex,
>
> Can you tell me what the I/O boundaries are for splitting up a read or a =
write
> request into separate subrequests?
>
> Does each RPC call need to fit within the bounds of an object or does it =
need
> to fit within the bounds of a stripe/block?

Hi David,

Within the bounds of a RADOS object.

>
> Can a vectored read/write access multiple objects/blocks?

I'm not sure what "vectored" means in this context, but a single
read/write coming from the VFS may need to access multiple RADOS
objects.  Assuming that the object size is 4M (default), the simplest
example is a request for 8192 bytes at 4190208 offset in the file.

>
> What I'm trying to do is to avoid using ceph_calc_file_object_mapping() a=
s it
> does a bunch of 128-bit divisions for which I don't need the answers.  I =
only
> need xlen - and really, I just need the limits of the read or write I can
> make.

I don't think ceph_calc_file_object_mapping() can be avoided in the
general case.  With non-default ("fancy") striping, given for example
stripe_unit=3D64K and stripe_count=3D5, a single 64K * 6 =3D 384K request a=
t
offset 0 in the file would need to access 5 RADOS objects, with the
first object/RPC delivering 128K and the other four objects/RPCs 64K
each.

Thanks,

                Ilya

