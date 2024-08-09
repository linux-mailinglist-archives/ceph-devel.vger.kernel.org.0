Return-Path: <ceph-devel+bounces-1645-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D7F194D03F
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2024 14:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 918F8B21DF9
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2024 12:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCE019308C;
	Fri,  9 Aug 2024 12:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="czO4VRw4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264731DFF5
	for <ceph-devel@vger.kernel.org>; Fri,  9 Aug 2024 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723206689; cv=none; b=soPcNo70MMmWfbWP5sUubMlz5TbxoL26iz4qAYcnPf5uRtC2DjyX7A9R9l1SSOs2Yt00Br9mB5DS0stEFdg3Ilo0yueQQP1dgJXioivPpGe6BLz2Wc/T21AdEb7oBE3qmUam2npdmallDBtkW+K7LEsx1hSRkHgB8UdaZF2WUXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723206689; c=relaxed/simple;
	bh=sCn/8ttdJ9XKHe13jdj84ncYWCsFEamDprYSTtZXcDU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tEWvGBBey8MVSZOuHcry3a5A18D5wzg11jgljpCZOPnCHCYuhFVOdPOoFZ3W1bT/hr/R71BYnV0IofmKBlbZ/rLmZ6ZbpDT893VJ6DIIwkgGqgZRseObM2ovlPtHJbcMn17Q/SOAgkFnc0K0VrQcJ/PfEpRyXmJbc7ZqbGwK9xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=czO4VRw4; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5a1c49632deso2199331a12.2
        for <ceph-devel@vger.kernel.org>; Fri, 09 Aug 2024 05:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723206686; x=1723811486; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N7qvO0/nGph6+v9f5JXZY71uV2oWBNV5Uz5aRtUfh5I=;
        b=czO4VRw4L4qRFe6XuIHpICfO/Axjni5McxnBxr763wNoZb6BItKVHAIQlpuw1iNxIO
         ZYqOy2pxK/0IEzLRZ3WcC3+G2IvoRQNIKzHzjvJUNLzYAq0Tqw42xoOD7Qh0oZMDmCx+
         Qf8gdn/PcTQX4S7sONQLCBuPx8P0a/0n3A9gYI7rs8l5jTbXBEzMJHSE4pUBXF4AepSQ
         KyLRmyTQiKiDbNsqOQBLmHpwFtkqYXInPTZsrEj2hCI9jbx8vOPbjx1kooe5rN6ZScAn
         Kn3Wg0jtAiIzrFtYFbyJG2IYaVomd8ClbwMaYL2nXiPqao0K7C7n12bmDdaltRWEuScf
         tmiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723206686; x=1723811486;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N7qvO0/nGph6+v9f5JXZY71uV2oWBNV5Uz5aRtUfh5I=;
        b=jlb+KpMaoXgR2DFjTGJECK6A66RncIQDmmdxFVFqOaIluxJ2KkXrdYiENtTKTRZIcO
         xSF1Sm2nf51/kOTCDXpXUXhn1y0oSQz/Na7H+5f/fUBOHpCnyQjOXKaoQ9dx6mts4IUq
         jG6zfp15hbyqnwlFqQ+BSaITB15peAMM7hpQCA2TT9O+aBPz6YR6rBDszh/kHGWuohZW
         FwAJQumaF48ADLZ8csv73D9IZdALj/r5XExIXQwcO+y0dq0HUEJyQ7WKZIfptTM83xoZ
         JbLIrPnXeq8yo3UCadWi1mzRc3zSD1CD5yWu0pyL9JtFz2wUiclk6DGKD66b6dO20XYK
         dihg==
X-Gm-Message-State: AOJu0YyqNbdtpaCz0UlyOSfC+QViFJQMqmGCQhyz0PFuthGElfM6Akm5
	xAP45QRM9ExE8G0l/a/GaQslvguzPRtUKUZ+zevrDlY2ZXvwmxUj9y/EG9Z5kbZlKunWcPUdGGE
	z
X-Google-Smtp-Source: AGHT+IGTeSMpMkBrGTD9KLazbzfUmoATeMLpqZ6c0rjhm+BN+gSKwT3CTHWPohEgM8/bQ/kpax8UOg==
X-Received: by 2002:a05:6402:2344:b0:5a2:1693:1a24 with SMTP id 4fb4d7f45d1cf-5bd0a5759c5mr1076352a12.15.1723206686261;
        Fri, 09 Aug 2024 05:31:26 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bbb2e61252sm1564826a12.95.2024.08.09.05.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 05:31:25 -0700 (PDT)
Date: Fri, 9 Aug 2024 15:31:22 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: ceph-devel@vger.kernel.org
Subject: [bug report] ceph: add new field max_file_size in ceph_fs_client
Message-ID: <6febcf36-2d30-4338-b1cc-641ddd14314b@stanley.mountain>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Chengguang Xu,

Commit 719784ba706c ("ceph: add new field max_file_size in
ceph_fs_client") from Jul 19, 2018 (linux-next), leads to the
following Smatch static checker warning:

	fs/ceph/mds_client.c:6157 ceph_mdsc_handle_mdsmap()
	warn: truncated comparison 'mdsc->mdsmap->m_max_file_size' 'u64max' to 's64max'

fs/ceph/mds_client.c
    6142         newmap = ceph_mdsmap_decode(mdsc, &p, end, ceph_msgr2(mdsc->fsc->client));

m_max_file_size comes from the user here

    6143         if (IS_ERR(newmap)) {
    6144                 err = PTR_ERR(newmap);
    6145                 goto bad_unlock;
    6146         }
    6147 
    6148         /* swap into place */
    6149         if (mdsc->mdsmap) {
    6150                 oldmap = mdsc->mdsmap;
    6151                 mdsc->mdsmap = newmap;
    6152                 check_new_map(mdsc, newmap, oldmap);
    6153                 ceph_mdsmap_destroy(oldmap);
    6154         } else {
    6155                 mdsc->mdsmap = newmap;  /* first mds map */
    6156         }
--> 6157         mdsc->fsc->max_file_size = min((loff_t)mdsc->mdsmap->m_max_file_size,

High positive values are cast to negative so we end up with a negative
max_file_size.  I dont' see that this causes an issue though...

    6158                                         MAX_LFS_FILESIZE);
    6159 
    6160         __wake_requests(mdsc, &mdsc->waiting_for_map);
    6161         ceph_monc_got_map(&mdsc->fsc->client->monc, CEPH_SUB_MDSMAP,
    6162                           mdsc->mdsmap->m_epoch);
    6163 
    6164         mutex_unlock(&mdsc->mutex);
    6165         schedule_delayed(mdsc, 0);
    6166         return;
    6167 
    6168 bad_unlock:
    6169         mutex_unlock(&mdsc->mutex);
    6170 bad:
    6171         pr_err_client(cl, "error decoding mdsmap %d. Shutting down mount.\n",
    6172                       err);
    6173         ceph_umount_begin(mdsc->fsc->sb);
    6174         ceph_msg_dump(msg);
    6175         return;
    6176 }

regards,
dan carpenter

