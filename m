Return-Path: <ceph-devel+bounces-1619-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D469941981
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 18:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3152EB2929E
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 16:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01021898E4;
	Tue, 30 Jul 2024 16:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="QnvKyE+P"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A53D189538
	for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 16:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357100; cv=none; b=HyM63TwErJHSR1/xMsdqi4Jd0tqxfB7AOUZXcXAlxxwUZhy5x+KMh/szofYe2KUHynE1BfjKoyEP9EtsYOSlYexnxIfqdAuisEfmqMS3ev2NWPuv5+U+/xADqqzoaDxmTtgBewiZBTZ/d3w2FBSfYlPdU/0rcgXh0ErvwudUBy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357100; c=relaxed/simple;
	bh=nyrerJDyhxrjVhddkZkyuAsVrv4YgfVF935QAWq/eAk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jzZnduQZL013mo92OWJDfLFaMnsUFA+ykQGjobpPFVUOz6VwBb7KViyUJ8BmC2pSNG7QBXqpAhyAvyk1a/1PtefkyXt3Hl4oFI+3PQuHXdEkq9O7KAf5YzqkotBIxAe/fIZqjJZH0Q/jWi+vH9S26K4/i5vwbY57swnxuiBuOyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=QnvKyE+P; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a7ac449a0e6so374317966b.1
        for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 09:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722357097; x=1722961897; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5cj6IhKT08G/JY9sA9ZAZBlaQGsxU+ED4GyGLcLHJ8=;
        b=QnvKyE+P7ei24VE0NqPYK3qsHjeemZi0qale+y13a3WGNC/yFv3GBiAmw0By4yXeLq
         chDpI2yu/44/lcwrtidEjFufcEWGYJlHMshTqSW9i6rgwXCrlWRB7w+MqhXKUCBB7Jc4
         ltl1mSZgefuYvaX2j2xHBm9uvuMmqtYKVN/AcQuFqfmKs6iHzP7NFfMf2vjcD8XRM5Yp
         9QnlC+TWA8R5mp46TPJvZpkYKEKcYXk2GSE5lyf3ICAG1tX6Rje3bqXUDzC1SmGjL4E3
         lAohMo5bN7gi1XmciGbR2jjmW2w2u5sKJJB2ilmSYAGdEWxazHWfKAyr95t+bDoTfTXn
         TERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722357097; x=1722961897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5cj6IhKT08G/JY9sA9ZAZBlaQGsxU+ED4GyGLcLHJ8=;
        b=YWnkl7dtkpmzFgufIpZsNNTwl9vWq6sN6Sb9mmfVyw2UpBj5p25FbZjWEN+jxaB+X6
         1BJc4b2CmGPH36jR6gGVfy9zjUeqJctO8Tt3SQpF97Nk1vfNv66KEZNMDfWPCRUNDx4v
         EfCl1qKEg7VGB4BKmRaMfRgYDYBCmYVJGfvhDjKQ1AN2UfbQUjVtECYGBqHAuDNy4F+H
         O4+hmGznqX5JzQ91FHiIoqNNES6T1HBVzVuhQwRn0fQf1h3WMEBYTMsR6vgEXnt/7ojf
         RVNh1IvWv5aJOiY4K8SgBSXrTfHpuBNFfDBh/T2Nze/rbP3/Y/Vw9Sb4ZLjyrDi6eEVF
         f00Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5tmaGnew0BFzReoho5Gk6YS3BhmG0iSTL9FBQpOBqL8/n02ExIVvJMBf+L4JqhYZkqn3EDGWp6f4rCOrG7ztiXcjEav45Tj+Lyg==
X-Gm-Message-State: AOJu0YxNQ8KRTYGNyUDfsAI9Lc61APyPLWW5sgUiyh8bEU8zwkKxDrdu
	mrdu6KsZlPDBZbOst/T4rChfKEgPhNn7tx5Ldhx3O9LgS0nolkdBwz7RNNozJlBzryoMh0N/S7f
	kNLDK7z7kltuPFeOvnZHC2X2Yodo/TFIvi4acGg==
X-Google-Smtp-Source: AGHT+IH7khnXrujEv1gKQnGzEfjEWyF4QEf2ukDbjiCueUR6RcV66FHsXp7NckoSkFnWoeFBMNqlnHILehdexStSq60=
X-Received: by 2002:a17:907:7284:b0:a77:dd1c:6273 with SMTP id
 a640c23a62f3a-a7d3ff7cb6fmr795199266b.12.1722357096904; Tue, 30 Jul 2024
 09:31:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240729092828.857383-1-max.kellermann@ionos.com> <20240730-bogen-absuchen-8ab2d9ba0406@brauner>
In-Reply-To: <20240730-bogen-absuchen-8ab2d9ba0406@brauner>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Tue, 30 Jul 2024 18:31:26 +0200
Message-ID: <CAKPOu+9DPbtpDOtmLf=kSvK8Vw7OQfET4-Tn6bHAcXe90HFpKg@mail.gmail.com>
Subject: Re: [PATCH v2] fs/netfs/fscache_io: remove the obsolete
 "using_pgpriv2" flag
To: Christian Brauner <brauner@kernel.org>
Cc: dhowells@redhat.com, jlayton@kernel.org, willy@infradead.org, 
	linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2024 at 2:30=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> Applied to the vfs.fixes branch of the vfs/vfs.git tree.
> Patches in the vfs.fixes branch should appear in linux-next soon.
>
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs.fixes
>
> [1/1] fs/netfs/fscache_io: remove the obsolete "using_pgpriv2" flag
>       https://git.kernel.org/vfs/vfs/c/f7244a2b1d4c

Hi Christian,

thanks, but this patch turned out to be bad; see
https://lore.kernel.org/linux-fsdevel/3575457.1722355300@warthog.procyon.or=
g.uk/
for a better candidate. I guess David will post it for merging soon.
Please revert mine.

Max

