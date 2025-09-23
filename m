Return-Path: <ceph-devel+bounces-3713-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9454FB95FBF
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 15:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01BCC2E01B1
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 13:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E731B324B20;
	Tue, 23 Sep 2025 13:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="yGwEv5jd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53037322C9C
	for <ceph-devel@vger.kernel.org>; Tue, 23 Sep 2025 13:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758633426; cv=none; b=KJ9th1wfORairaaU2eKa+BXv2EmIA7SzveMnvmRXOAnET27docniNuzQCT+V4cLJ0vVYbcXsaFQpMw6BySDEASGloEGpamqCLSZ0efbCLHi6eOv0xy84QXvanvs1tvi8awSCjprz8CtKmUdGhPueEfdJTUxRZ6SuldHr2fSzWq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758633426; c=relaxed/simple;
	bh=MjdyuQrqVvsTBegSnd3yU00JR+DMJq7p6mLUJWTlZdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/8CpRyCFwCDQFLOqHAwofGhEeH58kjQI2eODO/QMZJtp1CerxdBQKKQszn7nuHC8tnum1VmFLJPqlOLiSmhI0hIYEDd+kIFkiE8R65KQ8bb1j4Wr6sY1OAdNjOj2W6k52JGCeElGuyr5lJS1VnUpjoUIooPz8AsIEpg8G2LA8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=yGwEv5jd; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b55640a2e33so419869a12.2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Sep 2025 06:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758633424; x=1759238224; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DGZ8DWqCix+BtHtElOYwM96MkEfMXUBhKMzH5BSjHrU=;
        b=yGwEv5jdMt4Rgfi0m0bN3rxya9s2FAbia8xtqcTwhc19IK5r4PXmdK+C7UWreg1NfH
         4sk+1SJaFqWoZk8UMTPHgcndklOJpzScvLF5bjkG6gqoUSKB2k3ZVGlgvwgMKVkiX9tQ
         HMMHDCD3TrzFuqxXTV9HAJcgYYX2He2h5yQzLxkZURdzd28u2rXo3M/TKNd/GoKCTF5R
         SSJHzKnVcZ1kR/S8ehZjuwzeAqAlS4edQgRc1y0V8xkXIINs5b4r82gsRo8F8hz5liGg
         WFWMrwFtm4OO2twE/EkvNGL9ESDPBnyP6iVe3AlnhcR6cmuUPbA6c7z1EUU5XrhnwxMP
         WISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758633424; x=1759238224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DGZ8DWqCix+BtHtElOYwM96MkEfMXUBhKMzH5BSjHrU=;
        b=aQcLvM9pUv/FQzRUg/YO8rmfPL9v0VJT0xGFxqJjMsgM2iyAf+bYYBjhpg8d9SF8SU
         vNDOvpSu0oBRglLuOme5aLlFsH8C3gvw526Jbj9S5f7q7DMStjsClsRJNRx6tUTa77te
         5eGrRLiW+LvZx4KKsuHJw2lc1QejMGDb3iQIGd2O7ix9wlprmkDDswkyV1TNDwojbtk7
         yKrRPOR3+v9aJtRKtjykCxiKeL8VQx4qwdQ2T0eUj6g0v8g1dSYqGvHT+wOkVb1z0cn3
         Ig0V0pMsebq1ZWnl8+BZJKzy0anSyvmDQIejiXqQcgv3YZeVbfJtwTUhVWxu11q3ccdv
         R2QQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMZaaVK33AQhn283MHck32dyZr5fLItguFC2ffXdA+7jH6QEgASISg6nugvMsGps8xp2/Sd1OfxRNo@vger.kernel.org
X-Gm-Message-State: AOJu0Yze5AzpwMJMWjm8LRqMF5CJ2//hfp53iye6zD6JtjYO4bDSKYSu
	+NstS2Qp0bvYesa0pYZ4VfF07H0mYdDah4nYiSEIQNZiZXl2pwOcv+phhEM5vNulw3Zurv2iO8t
	bnWCp
X-Gm-Gg: ASbGncu1Zd+ly2dwaFixMmkilhjcnx6ZoBY0kiTCY/75zv7hi38VVR7D5jzf0PpLLgl
	CLMqT4jYJAnAIBxJ0Hm4nWFOIsQiPohT6B5sgfQ1YCPvVWTFIBL1Z82uZNOS9fyfmuDAj0EU1K5
	X0d4rpC09ID8sH2vLuGs4ChcWS2qa0Ct+lLjNd7Ftg6dHfkQkYN61LYer7vBc6fvEAubFtNEn3+
	3CTMzRNIfVsQZ0auutNmWBfQsY8IKFCUjRWLf0zGZ9DxKoPOTDMrif7v7Uslx9VR04im5imqQXY
	z8DjicBzskSP9dFA2Dqgwi3cA8U6WF7fR/sInGS4GVxB5kY6v1Sl4ou6gxIHsD85iL9WuG8bgSL
	SF6fReT86YSy5kFsOyFwAYDj0j9sblse16A7PHS5rZWhCK6QjvEvi1O2MbTE9aigL22lDi8y0bq
	Cl/jZlam6T
X-Google-Smtp-Source: AGHT+IEK7PfWxNFc7fb1bUErPP+++ZIWocUE2B9M31SxyszIkGAjugG30aXgLbzSTbCpFRJZYYXACg==
X-Received: by 2002:a17:90b:17cc:b0:32b:9750:10e4 with SMTP id 98e67ed59e1d1-332a95e0514mr2945365a91.27.1758633423462;
        Tue, 23 Sep 2025 06:17:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b551705bd02sm12047994a12.41.2025.09.23.06.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 06:17:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v12t9-00000005h4t-0IOy;
	Tue, 23 Sep 2025 23:16:59 +1000
Date: Tue, 23 Sep 2025 23:16:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v6 0/4] hide ->i_state behind accessors
Message-ID: <aNKdy1vYsWoMvU3c@dread.disaster.area>
References: <20250923104710.2973493-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923104710.2973493-1-mjguzik@gmail.com>

On Tue, Sep 23, 2025 at 12:47:06PM +0200, Mateusz Guzik wrote:
> First commit message quoted verbatim with rationable + API:
> 
> [quote]
> Open-coded accesses prevent asserting they are done correctly. One
> obvious aspect is locking, but significantly more can checked. For
> example it can be detected when the code is clearing flags which are
> already missing, or is setting flags when it is illegal (e.g., I_FREEING
> when ->i_count > 0).
> 
> Given the late stage of the release cycle this patchset only aims to
> hide access, it does not provide any of the checks.
> 
> Consumers can be trivially converted. Suppose flags I_A and I_B are to
> be handled, then:
> 
> state = inode->i_state          => state = inode_state_read(inode)
> inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
> inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
> inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)
> [/quote]
> 
> Right now this is one big NOP, except for READ_ONCE/WRITE_ONCE for every access.
> 
> Given this, I decided to not submit any per-fs patches. Instead, the
> conversion is done in 2 parts: coccinelle and whatever which was missed.
> 
> Generated against:
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=vfs-6.18.inode.refcount.preliminaries

Much simpler and nicer than the earlier versions. Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

