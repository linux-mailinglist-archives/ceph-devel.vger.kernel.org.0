Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D98E26E28C
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Sep 2020 19:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgIQRgD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Sep 2020 13:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIQRfw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Sep 2020 13:35:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DD4C061788
        for <ceph-devel@vger.kernel.org>; Thu, 17 Sep 2020 10:35:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id kk9so1579927pjb.2
        for <ceph-devel@vger.kernel.org>; Thu, 17 Sep 2020 10:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=iGnBAUxmMuPK4xQ5Y7oYxfqh4wG5+fibl8Y6iEq9y+8haP9Z+QmAuvSafBD2FNOkLm
         1L22du7YtY+N0DzNHpYGbX05YHKHfRVhXheuYrN2z6jvF7oFonS3I3mcUTRSfLk+0/fO
         uRP6vfnG5z8bNsUY7ex5WA51xZeuIY0p/Q/s5SKKcfCZ8W9sa2X6nuplEMuxmjhquTUb
         1nvhVljpQ/rYgfEd3dJ9FfpWO0bptOeF9J4qW2nK9n/II85YroIT0GcdmvlQLZMFQi74
         UYzgCvvti1As/Ir0KdMH1NaX/uCvpeebO0b3xWJplEN3jt/UWcV7PjmIpPXgCn2hVa6B
         Vluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=QmP1SmgMB0HbQR76aORN9DTYUPTNEAjbQOKrJ13i1xoBSNhucYvY3z6+FkY0XVTzaG
         ynQT4D2gqG7mGAN1Vg3e/5CSiO7RvOtmAJQ7ufYRiClH/Uz+gH6B5DNx+EMwZ2bscKrN
         KYYIYHR0dF/jD/EBuMuIt2L+apu1oah9oW5a981FOnwQFBPicDwTQN5is9lHhhmpfQDY
         k6sBBBSsKuFO+s5J59n/1sO15jW1Yh1LVLWFXkDvFgmLZ3h34V5PcDM45d7UouRtq6oQ
         U5SY9gQya66R6iibdSaoYnok9uiEExJWgTdg/Imo83bwpkzUX/mWz3Xl0BBi2k+9dsHu
         vsug==
X-Gm-Message-State: AOAM531QwDEJNVxDfmgZUYiVG8wWT/DmRDZp7m83srdYI9PbSzgXD3Mx
        RjFi1nBpVuD7KS+MlYc9kO+/g3nCoj8KMw==
X-Google-Smtp-Source: ABdhPJyuPuqf3tfAZKH4+Y/IVWYtFfjV6qk7ss4WMJUY/nK0ymarrPwj076fOdRwEwYYNSRSisGygw==
X-Received: by 2002:a17:90a:54f:: with SMTP id h15mr9727980pjf.191.1600364128411;
        Thu, 17 Sep 2020 10:35:28 -0700 (PDT)
Received: from ?IPv6:2605:e000:1600:d493:7057:dece:8f30:10d0? ([2605:e000:1600:d493:7057:dece:8f30:10d0])
        by smtp.gmail.com with ESMTPSA id r206sm230863pfr.91.2020.09.17.10.35.26
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 10:35:27 -0700 (PDT)
From:   Dan Jakubiec <dan.jakubiec@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: 
Message-Id: <BF788DB6-892C-484C-82FC-5F9E94500161@gmail.com>
Date:   Thu, 17 Sep 2020 10:35:25 -0700
To:     ceph-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

unsubscribe
