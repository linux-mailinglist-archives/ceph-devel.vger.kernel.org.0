Return-Path: <ceph-devel+bounces-1133-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57DD88BBAA7
	for <lists+ceph-devel@lfdr.de>; Sat,  4 May 2024 13:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F21912824B6
	for <lists+ceph-devel@lfdr.de>; Sat,  4 May 2024 11:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C0617C7C;
	Sat,  4 May 2024 11:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WxDpsC4z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A804C9D
	for <ceph-devel@vger.kernel.org>; Sat,  4 May 2024 11:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714821797; cv=none; b=VmD7RM8Yajpk0+LyXVnH9tM7qyIghH1uLSVDRkBAfRTob4r0SXxa4PLcytwotUh0xYzHe8CRKbD2+6onCMbV5IAUZ/Grbe3kUKmf/jPwwHDo9yxOLr9k3xIpliiQepcQQpem541ckuPtrs01MDF2NYfqyldCu99jVjsieDEQ+50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714821797; c=relaxed/simple;
	bh=nzq406uOC4To9YxA1rtM4dRXj/CVM05dNP+jYYvWWAM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jSAHDG8E+Sw5C1h/ZLHe4te7xWAxbbXPKitf5QHuM3ohqgWCMSIG/JWVLN4NojDi66r8gGlyUSijX+NTC+VOgS9xb/IfELIyjzcGd9nlRsXQsFF1rUnItPBvykbVmZ+c0zv1kLjzz36BXAjDypYdCqbxGRhgsirHaZU3sa8UtU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WxDpsC4z; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-41adf3580dbso2393005e9.0
        for <ceph-devel@vger.kernel.org>; Sat, 04 May 2024 04:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714821794; x=1715426594; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YXchWMwvtaueIr8HpH6bHAEwGBvyjWsDOTfoyis6uk4=;
        b=WxDpsC4zCx42orj00ymDkIZPtj8nePJbmW36wwf4C8xsc1WhNCaNYc4DSDQ2+2jnCZ
         Q7znnLUHXuK+4qcYFSOpZC3SykQS92G2aFfsEVk2ZXRA5j0ivxpByvJeuTru0fEJTH+8
         xBSlCd4mudhSYG2d8lvwVfr9rmEv+JDvECQSA8nG7/qnVfpBI1Kwx8XIFdS97vcrtGIZ
         EDC+1wZBDfGL4mIftVw7jcAZhwCkVHoGhliFJr5bARmKbzizdjpeqTIW/0eFCau7tOyj
         odZxjn4rngCEojyruaE9IUVmewphb/XO4Xduq8bmKlrasuCqGbtVGisxtwYlEf3WVdV3
         xC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714821794; x=1715426594;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YXchWMwvtaueIr8HpH6bHAEwGBvyjWsDOTfoyis6uk4=;
        b=lEwAkMHyUPZlwESVyRRNK9HIIPDtgX2WrmOwJYcPy9nyAubqtMDOoo/i4vbuJrl2Jb
         YudioS/HhQmX4emrYzAkPVMxHGqO4aPMTOORjICgzxLHwDZV1ZQC2PbvtKXRExoKTQOz
         vTxF464MxYEFkuxhfPzTfl+xLZPyaTu6kWL/AmcD7EyVh/FbKb97imzewve7jtnxFtMo
         Pdo3o9ed3tNMesmoVLf0bOSXSWvHmBoS0lUKlGBNVeSoSJqwe3jz6tJwURUkLEgmDAko
         x4arnqHNveb6j4BJMa/48hxrCGR+VhvBVvbYHoQVE0R97Zw7QlRVmpvY1VCXVZ0BGCbL
         EayQ==
X-Gm-Message-State: AOJu0Ywpx+AVnfr78v3UjWrnU5D2fCX7bc9aU5OIjoXoGDzwTFNYifOO
	d9/ER35uCqE9lPqiTvYSIDsDHwxCDG0diECacqzFPWu1Hg+ByM9AQTuBw75GdxM=
X-Google-Smtp-Source: AGHT+IFotzaVczH7uq3A15Hmn0A06167+r9aBE1mV29vV6WImFPONLQ7de6Mqn1y1zTL+Vr6JND0eA==
X-Received: by 2002:a05:600c:4fd4:b0:41b:ed36:e055 with SMTP id o20-20020a05600c4fd400b0041bed36e055mr4826790wmq.7.1714821793574;
        Sat, 04 May 2024 04:23:13 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id p20-20020a05600c469400b0041bc41287cesm8945252wmo.16.2024.05.04.04.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 04:23:13 -0700 (PDT)
Date: Sat, 4 May 2024 14:23:09 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: sage@inktank.com
Cc: ceph-devel@vger.kernel.org
Subject: [bug report] crush: remove forcefeed functionality
Message-ID: <379ff867-95b7-4d45-8973-d4d0867e78b7@moroto.mountain>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Sage Weil,

Commit 41ebcc0907c5 ("crush: remove forcefeed functionality") from
May 7, 2012 (linux-next), leads to the following Smatch static
checker warning:

	net/ceph/crush/mapper.c:1012 crush_do_rule()
	warn: iterator 'j' not incremented

net/ceph/crush/mapper.c
    1004                         for (i = 0; i < wsize; i++) {
    1005                                 int bno;
    1006                                 numrep = curstep->arg1;
    1007                                 if (numrep <= 0) {
    1008                                         numrep += result_max;
    1009                                         if (numrep <= 0)
    1010                                                 continue;
    1011                                 }
--> 1012                                 j = 0;
                                         ^^^^^^
The 2012 commit removed the j++ so now j is always 0.

    1013                                 /* make sure bucket id is valid */
    1014                                 bno = -1 - w[i];
    1015                                 if (bno < 0 || bno >= map->max_buckets) {
    1016                                         /* w[i] is probably CRUSH_ITEM_NONE */
    1017                                         dprintk("  bad w[i] %d\n", w[i]);
    1018                                         continue;
    1019                                 }
    1020                                 if (firstn) {
    1021                                         int recurse_tries;
    1022                                         if (choose_leaf_tries)
    1023                                                 recurse_tries =
    1024                                                         choose_leaf_tries;
    1025                                         else if (map->chooseleaf_descend_once)
    1026                                                 recurse_tries = 1;
    1027                                         else
    1028                                                 recurse_tries = choose_tries;
    1029                                         osize += crush_choose_firstn(
    1030                                                 map,
    1031                                                 cw,
    1032                                                 map->buckets[bno],
    1033                                                 weight, weight_max,
    1034                                                 x, numrep,
    1035                                                 curstep->arg2,
    1036                                                 o+osize, j,
    1037                                                 result_max-osize,
    1038                                                 choose_tries,
    1039                                                 recurse_tries,
    1040                                                 choose_local_retries,
    1041                                                 choose_local_fallback_retries,
    1042                                                 recurse_to_leaf,
    1043                                                 vary_r,
    1044                                                 stable,
    1045                                                 c+osize,
    1046                                                 0,
    1047                                                 choose_args);
    1048                                 } else {
    1049                                         out_size = ((numrep < (result_max-osize)) ?
    1050                                                     numrep : (result_max-osize));
    1051                                         crush_choose_indep(
    1052                                                 map,
    1053                                                 cw,
    1054                                                 map->buckets[bno],
    1055                                                 weight, weight_max,
    1056                                                 x, out_size, numrep,
    1057                                                 curstep->arg2,
    1058                                                 o+osize, j,
    1059                                                 choose_tries,
    1060                                                 choose_leaf_tries ?
    1061                                                    choose_leaf_tries : 1,
    1062                                                 recurse_to_leaf,
    1063                                                 c+osize,
    1064                                                 0,
    1065                                                 choose_args);
    1066                                         osize += out_size;
    1067                                 }
    1068                         }
    1069 
    1070                         if (recurse_to_leaf)
    1071                                 /* copy final _leaf_ values to output set */
    1072                                 memcpy(o, c, osize*sizeof(*o));
    1073 
    1074                         /* swap o and w arrays */
    1075                         swap(o, w);
    1076                         wsize = osize;
    1077                         break;
    1078 
    1079 
    1080                 case CRUSH_RULE_EMIT:
    1081                         for (i = 0; i < wsize && result_len < result_max; i++) {
    1082                                 result[result_len] = w[i];
    1083                                 result_len++;
    1084                         }
    1085                         wsize = 0;
    1086                         break;
    1087 
    1088                 default:
    1089                         dprintk(" unknown op %d at step %d\n",
    1090                                 curstep->op, step);
    1091                         break;
    1092                 }
    1093         }
    1094 
    1095         return result_len;
    1096 }

regards,
dan carpenter

