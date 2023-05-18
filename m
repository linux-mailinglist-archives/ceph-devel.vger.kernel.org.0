Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D95707ADE
	for <lists+ceph-devel@lfdr.de>; Thu, 18 May 2023 09:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjERH3t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 May 2023 03:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjERH3e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 May 2023 03:29:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371674486
        for <ceph-devel@vger.kernel.org>; Thu, 18 May 2023 00:28:57 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-643557840e4so1869666b3a.2
        for <ceph-devel@vger.kernel.org>; Thu, 18 May 2023 00:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684394925; x=1686986925;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oDVdWICwavrWQ8UAVYhe8ynFXsBBW1vVQ7W08zgiq24=;
        b=F3FDvHLry+67ch7rgRt9RrTaHLyQL+GDY+bwWXtJFqlcMyGU3f8RYLoxp2/EZfZRB+
         tUFyJSIqKPaiLYRROp3+wHvXctWyUPsJ8uMBdPT6tRW830fhK3TAN5kqXG5vhOfcv4Dt
         mVQeu9f1Ud/6k8Ai6bYFHnaSG9fbjfruIivWVdKHh+COMEMuwj7biiIsmUgBtwhw7xu9
         2mNV5taHm9SwGLJOPj1NUsldh/wHah5Dr7KfGIyh3spFiGtEK7mWhV+zT69tMWfmswYA
         X8Ez3x+RG6cGdPM/myrmtdKzqqhmEqtFk2G8bFFhzRQqlGp5YkIONhoJ2ZOU12+btTcn
         XAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684394925; x=1686986925;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDVdWICwavrWQ8UAVYhe8ynFXsBBW1vVQ7W08zgiq24=;
        b=MyS3QxI6N6q0QvvzjG2v9iumhw7Rv7cleZPsyVDSv2Spe88N6+5HKSaSAQmY3M5rP4
         i6pyYyigAb+GEwpYVSD8CvSnd50wDdO6qdCE1mrKUYv0F+lsB7YlPFFmBZySAN7n9UXG
         yMErkW/FR4P37ZiYTFXzGuT8gSFTcO+womVDN0WHfbnhOqAa/8PQAQpYSjKA6WAlCOlP
         iGsQCEwgxOjCpJtt8+MJV+mTXV3sMo/OCsXDCuieNzxcA3w6sZ42DlGTItdkl31SIkR/
         DZJKkVm9RnK92yg2Z97/znK19ve2I9vrKYDKoL3z8KjQ6fda2iTfiUX/3x3avvueyx9Z
         9ibw==
X-Gm-Message-State: AC+VfDymbAcXNKSRoLyqpVcAzpu94/GQXlYHICs32Mm7ujMI41gSePIR
        3dsbI1uGyIea/RXLQ2ceN7pulSFbSaGSXF1m918=
X-Google-Smtp-Source: ACHHUZ6freRWOs227ZVzHMEMoL2jvROsTWiV/x1jxHB0eIC7WPVEwC//YCk8U8FT20WRFr3biELbShAmT9RPDRDzNSI=
X-Received: by 2002:a17:902:e5ce:b0:1ae:5f7e:c117 with SMTP id
 u14-20020a170902e5ce00b001ae5f7ec117mr2004947plf.60.1684394925333; Thu, 18
 May 2023 00:28:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:e108:b0:470:f443:15ec with HTTP; Thu, 18 May 2023
 00:28:44 -0700 (PDT)
Reply-To: contact.ninacoulibaly@inbox.eu
From:   nina coulibaly <ninacoulibaly30.info@gmail.com>
Date:   Thu, 18 May 2023 00:28:44 -0700
Message-ID: <CAFb7D3dM+oxnE6SbNfvtRU+Y0hm6-dFzOeWdxnCfTbyrh68jVA@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear,

I am interested to invest with you in your country with total trust
and i hope you will give me total support, sincerity and commitment.
Please get back to me as soon as possible so that i can give you my
proposed details of funding and others.

Best Regards.

Mrs Nina Coulibaly
