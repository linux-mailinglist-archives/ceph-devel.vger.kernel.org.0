Return-Path: <ceph-devel+bounces-3456-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BCF6B27975
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Aug 2025 08:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00A851898BDE
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Aug 2025 06:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F092C0F97;
	Fri, 15 Aug 2025 06:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FmkyRaIz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA63278E7E
	for <ceph-devel@vger.kernel.org>; Fri, 15 Aug 2025 06:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755240609; cv=none; b=kLLlVAMThqc18s0lgks8DZSw1Mq6SxIJ5srB4+xBDPkm3XVbqZvNKqtblNH6TGfe8UtuN/h3WJDcdLyeie25FnFfwV6Ube1r7rDuqAzK4ALR1kJmmb4SjERJYacMK0z60UEQVU9Pr/z72+v8JHglpTYI+2rq6g9q44lvLiJO0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755240609; c=relaxed/simple;
	bh=Nah/YCPnC6YaJJ67F2xS5r+tT+LJR+/va4rzKA1XsIc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NG8nIV7JtUYZFRk17ISeNSEkHu9QTuWqIQwY5s1+VklsIosODlKFVFL5JZ88Fi/NnmiOy1OP8hdx0ftZcA5bkUQCD1MIma+O660+6oLCkhAIExEpLofoqv6FIEbt3UwaSZluKYQEeOmtGojR+SpHHLxZeVYrbyxSTaKB5hqaVlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FmkyRaIz; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a1b0cbbbaso11754115e9.3
        for <ceph-devel@vger.kernel.org>; Thu, 14 Aug 2025 23:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755240605; x=1755845405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EO79QixeIU2AFjPx21qsezKBVSAseCTZtAXPDRxyKm0=;
        b=FmkyRaIzDCbORwr4AdoYth3M5aHrJlAwJ7sBxbbABmUmMhL+C4dVsbqef1QfGbYJza
         t6z9ZXzby1kkyzQfx6reipvQODXYCHj6fF8l2JRL3UAyFIBvRBsFx/VY+6N788l8Iwai
         YpF1He0kGMe3eLuz4nLPp17hQLgoWJtfEioRTq16RCnsk2HyFNznA3e3mHEnR1Nuuq9G
         XKPOtnVLPfxe7KwE7kSnQxqjGrBX9oaCbammpj5wno73rDPoq3cuyY903FO6kNndjzow
         JnZ5UGORpkZVerIblfo6Q+DHwx3oNsUxxOVThNs1YsBcwa4BNElatSw1fRB1RHvhFlKC
         yduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755240605; x=1755845405;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EO79QixeIU2AFjPx21qsezKBVSAseCTZtAXPDRxyKm0=;
        b=UP+8iL0GfIAaL5yAekxHPJ70tCBAxHvT7FXEetrLs17qlf59rJZ9ayirlbeqS/oh/X
         hIOJFsJ6nRju57mRizgnELgSMHFGe9bzkC6DZ+g/JWmr/0eWDZJdvKa6tHAFD6P4OISi
         6w7A83ou3ciPO7QiG0gwilyMm4GWqaqe4gtXecfy+rB2D0p7u9HoTg/IacFZ/nTMKEv3
         0ATNJx22E4sQc0UndruvNM/Nt1ps1vbZDaXiGdGh3jpecY+c9BsBrz4mIIL33Fa3gmHV
         +qCjfjEsYmluX8CCFGYWBzQvDAKRaDZZdnRwlaMCiXP1dIar9ZvW9t9QM+0PZHe1zhpB
         6XLw==
X-Gm-Message-State: AOJu0Yxm5SGdS3Ad1MJrhBP2k7NviKSnqW7i+mFjhUXCVUiI9jf6hPKp
	K+4VF8U64FBKbitXrjA540D1pPgC4qraU6zZ7vNi4vhzOzKK76Y3DE0gRGc0t0t78tM=
X-Gm-Gg: ASbGncuuPUZG0vKU7w9BHZd3rzX234in7eIm/E6jinN0Me3X/wD3fDPSNb/9GXQf9Be
	hRqWwBr1160vyyxIOSOd17mGlwvew0C+fnvzOz5H5G1BnVsN9f+XtliiermC78lTIxitbRAdepe
	/ixG6ny1Vm0AGBBXS9aeiCqI3UJFPN2RV6R+osasVOeJRavn8gNEZMy+GL4CSCDs/IPHDg5TBoo
	g1zn0Ijlhj1FS6wrJMmberLtPHlVU7XtrJpeP0oPYpHYLLyY6R8w/pwwPnrAjSmSYNqqL1cH8sF
	tPTb4M7S1jjTMKvhPB73xfXX5vOCjbvoT1oEum5zEpFiqdPAlbL2+SjL+NZF+vf85YjUqSDgGPk
	QrtD2rXAP794x7Ea71oDY8CCqZn+PpR0mhPJcl28ugMw=
X-Google-Smtp-Source: AGHT+IEy3kyJlZdH56QOuGkHDJdhjgnc7VxsA3gmSaha2RbRVBnnh+VR1ppHxsbrSWfIfXe7dA0qUA==
X-Received: by 2002:a05:600c:1f1a:b0:458:bfe1:4a81 with SMTP id 5b1f17b1804b1-45a21844af6mr8757375e9.17.1755240604697;
        Thu, 14 Aug 2025 23:50:04 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3bb64d33340sm824225f8f.21.2025.08.14.23.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 23:50:04 -0700 (PDT)
Date: Fri, 15 Aug 2025 09:50:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alex Markuze <amarkuze@redhat.com>
Cc: ceph-devel@vger.kernel.org
Subject: [bug report] ceph: fix race condition where r_parent becomes stale
 before sending message
Message-ID: <aJ7YmI6alo2Yg2wo@stanley.mountain>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello Alex Markuze,

Commit a69ac54928a4 ("ceph: fix race condition where r_parent becomes
stale before sending message") from Aug 12, 2025 (linux-next), leads
to the following Smatch static checker warning:

	fs/ceph/inode.c:1591 ceph_fill_trace()
	error: 'dir' dereferencing possible ERR_PTR()

fs/ceph/inode.c
    78  static struct inode *ceph_get_reply_dir(struct super_block *sb,
    79                                          struct inode *parent,
    80                                          struct ceph_mds_reply_info_parsed *rinfo)
    81  {
    82          struct ceph_vino vino;
    83  
    84          if (unlikely(!rinfo->diri.in))
    85                  return parent; /* nothing to compare against */
    86  
    87          /* If we didn't have a cached parent inode to begin with, just bail out. */
    88          if (!parent)
    89                  return NULL;
                        ^^^^^^^^^^^^
This returns NULL

    90  
    91          vino.ino  = le64_to_cpu(rinfo->diri.in->ino);
    92          vino.snap = le64_to_cpu(rinfo->diri.in->snapid);
    93  
    94          if (likely(ceph_vino_matches_parent(parent, vino)))
    95                  return parent; /* matches – use the original reference */
    96  
    97          /* Mismatch – this should be rare.  Emit a WARN and obtain the correct inode. */
    98          WARN_ONCE(1, "ceph: reply dir mismatch (parent valid %llx.%llx reply %llx.%llx)\n",
    99                    ceph_ino(parent), ceph_snap(parent), vino.ino, vino.snap);
   100  
   101          return ceph_get_inode(sb, vino, NULL);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This returns error pointers, but the caller only checks for NULL.

   102  }

regards,
dan carpenter

