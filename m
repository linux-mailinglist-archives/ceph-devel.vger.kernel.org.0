Return-Path: <ceph-devel+bounces-2847-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C86AA4C3BE
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Mar 2025 15:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A04C918960CB
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Mar 2025 14:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C912139DC;
	Mon,  3 Mar 2025 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="lLccm+L+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD470213E61
	for <ceph-devel@vger.kernel.org>; Mon,  3 Mar 2025 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741013181; cv=none; b=aIFU92zPRNKof/L0XFsJsXO5SRHIYSHCG8NeEXRfwGlhzovepi5EqPEqXJ95i3LebsFzLLaQW7CJe6M10hzpaAgguURRdemSI5ITqThXQfVG0KD8gu8A2Z3D3uRNwurxcv7+SUoDT+qYQX0PsSyfnt3TpkaKoNN80y5WWUDOYF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741013181; c=relaxed/simple;
	bh=CSQeGS/UZUc31BUvv23G8CVIkT12nQMGyFgBEwHK2pc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y+vwFpfrXAVW+55xVJyv0KmrTH4q/DnBPkiOeSIAgdge7i5yanrtsMpaeCpqYH35ixPMwa1g0mBNPhKBqs9DilaBY6lc/9A0tI4nHgVZrGQAX7qSepKrTcqr8ADA2I3VpeFJsx9YvE9jEjH2g0mis8FKUgjqm5XTd0wLKupNEEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=lLccm+L+; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-471f88518c8so23270541cf.0
        for <ceph-devel@vger.kernel.org>; Mon, 03 Mar 2025 06:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1741013179; x=1741617979; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qjaplGXAgQys6n43UvZfkCCurGUYwKZfvrBKCJx8kSQ=;
        b=lLccm+L+C5gyQVjYsYDdL1zeNxIZuJZGkpcU6/9jM/EGmEqxoX9VEq8LeF0hguc262
         OrZIVKmCGpEWYzV9XpeB++QZRuh7XVQ12POq2Tyc80nMnleI7zn72I1w46yYtznIxQfb
         g0BdLTnqzhNoiDvBa4YtqzHg1bvB09UzU6OUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741013179; x=1741617979;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qjaplGXAgQys6n43UvZfkCCurGUYwKZfvrBKCJx8kSQ=;
        b=uVErKny8nOS5wyAyHaztUwoREO93L8UnkbSozuGpxzDV3YeHMqkwrKvQ2zu6xEuIII
         ozmEXGCNgRB61cwyJnkK3wFkETOJC7CYDq+tZ00miUC0ZDfIJM+0XMtabhGzbMoyx9Kx
         WqJhFPvrFA04F5NjW4yBrK+an4fplh4K/pfe9Hk6Tz3GkNSJ+TpacN1oCgJy+byJAiLa
         qfCnNL2f0ADRD6Y1oUQpsj828Hx/IIm2qPeOuDGo2/UPgy/0IlVMPB68dvh28QnoNMYU
         luDSvMbF7X4Oqu/jOi1dPjpvTn7wPYIYavrcyrHF5r/awPXomjwJsRCS+j3em88xz60i
         E5BQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyjXLpPVl6dXVP1dhPDuTb6eK0HoeIx0FfAPy2Qlt1nTrBshw46SbOvfWunwO/6svHtLhg6CZ27BtY@vger.kernel.org
X-Gm-Message-State: AOJu0YyMxV14OgrnoWxqnteFrb5InyXXLIUazg3rvDK3mNG0D/ZlMrhF
	aKTwsdRCDb3j7oLSX4Te4JKd4lpT/jJq1am1ihepMLBfOv+GaoqtXYxnMBF/cqChNHG56F2VmRB
	xJ1HTtJADO3murWql65Oq/UxUWMzGE4SfPBKI5Q==
X-Gm-Gg: ASbGnctlV6rnz3FO9y6fRQn9ulvBHhdA1bQGwBDXjn/+r61YxesUnjr1ZrzuG431ONp
	j4K0CTHL1ygbeqUG7SdQ1IcJso2hSVRsNWRaG3Hy/Qc0u2aWJhxjAqTvwlHI7XzeCweeVvjzIOg
	ncuZdwPEWFCblwcgTWkj3GIEc2Xtc=
X-Google-Smtp-Source: AGHT+IEc70lGyxC8HHKIoOrpie2Jx8XsivN2M9IFYtspzolVa0r9jSj5J487Smay6+rDx9jahhDHL5KyYqxP+yy2+fA=
X-Received: by 2002:ac8:5806:0:b0:474:f484:1b4b with SMTP id
 d75a77b69052e-474f4841d3emr20114471cf.23.1741013178811; Mon, 03 Mar 2025
 06:46:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250227013949.536172-1-neilb@suse.de> <20250227013949.536172-5-neilb@suse.de>
In-Reply-To: <20250227013949.536172-5-neilb@suse.de>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 3 Mar 2025 15:46:06 +0100
X-Gm-Features: AQ5f1JoUFcZgsP72xjJitgL04_WZu20xfL4s-mJeajhIk4Eeu4PYIyUzi4H_ijM
Message-ID: <CAJfpegtu1xs-FifNfc2VpQuhBjbniTqUcE+H=uNpdYW=cOSGkw@mail.gmail.com>
Subject: Re: [PATCH 4/6] fuse: return correct dentry for ->mkdir
To: NeilBrown <neilb@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org, 
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	linux-um@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Feb 2025 at 02:40, NeilBrown <neilb@suse.de> wrote:
>
> fuse already uses d_splice_alias() to ensure an appropriate dentry is
> found for a newly created dentry.  Now that ->mkdir can return that
> dentry we do so.
>
> This requires changing create_new_entry() to return a dentry and
> handling that change in all callers.
>
> Note that when create_new_entry() is asked to create anything other than
> a directory we can be sure it will NOT return an alternate dentry as
> d_splice_alias() only returns an alternate dentry for directories.
> So we don't need to check for that case when passing one the result.

Still, I'd create a wrapper for non-dir callers with the above comment.

As is, it's pretty confusing to deal with a "dentry", which is
apparently "leaked" (no dput) but in reality it's just err or NULL.

Thanks,
Miklos

