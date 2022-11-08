Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FA962116F
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Nov 2022 13:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiKHMvi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Nov 2022 07:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbiKHMvg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Nov 2022 07:51:36 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80A213D75
        for <ceph-devel@vger.kernel.org>; Tue,  8 Nov 2022 04:51:35 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 5so8761851wmo.1
        for <ceph-devel@vger.kernel.org>; Tue, 08 Nov 2022 04:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=Am15aRt3/FFU3AABqlZJ1Qu6rTELZlCMJGJyoga0tfV+PoNrNqItL7v9h3LdP7EQG/
         ARNG5+3UyvynUgChwsGJk+z/DHB7BuqXqE63maSEKxF6sCf0qTco2iHHewCZQLWy2Sb5
         buWinopCQyYL/GS/AzilwBJiG3RTqCHYtlV6w563BvF1P91khtFhVzfJCz+B6GYjZ7rI
         oqbHKRFrrn/PYA7/JDa9rcnlTngus7JjjdGhbMpiixGILid2GHd8TUti5bXBgOwku8pv
         IglGYCbAXKkdR/54UxO1I13OYHilLWu/M8jCoojeOjCjRa0L9rtqS111y+NYjGCeK1sX
         /3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=0FNyRvJvenwUCa4ENt0DHQi6Xnv1FHkDo+9NZNFBiCoZlCd1yKlrwdTZkRpWX3wCfi
         DmLcGy/5GQSRi5uXg17rtolhQIg/Ewj5p9t6rHe5qJFviBMJ3cNslr3YQvle9APtjL/b
         KqYNCOFVkMb3SkWnNvIkBL/M1+opWvc7ihfA0SR8svBWGuTbjabNfVCEhCZhSKqFjQEk
         hcIbx7rm3nwnVGzUMadOIo0YZDgx0jkoxz7FT3sAvVCnzCqNQKw7SCpiYei+hEM94THw
         AIZzWSlvGOhwsvN2urqcDNHpI/Hc5Dp1sFZEIcgyI/4o+HsCQqS24HlVXsqDtqk1mSpY
         WzXw==
X-Gm-Message-State: ACrzQf37ux6nT3eA0MfUTEJ/Q+TYsrRkZifMaftDr2vV4aGwLuy4Aa5g
        WJ+KirGEVStbRA8FC1mhA1PO0YYnvAzSN4MEZ88=
X-Google-Smtp-Source: AMsMyM5FovRJgRLLDXtWZXonAnwXdL8xgWxfq76DlZDmoYz7jZFpsz/Qj75meDiN8TGJxiqTkitKPbdlVpsQmIe5WgE=
X-Received: by 2002:a05:600c:6023:b0:3cf:7dc1:e08e with SMTP id
 az35-20020a05600c602300b003cf7dc1e08emr27375148wmb.154.1667911893959; Tue, 08
 Nov 2022 04:51:33 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6021:f08:b0:22b:1bef:1706 with HTTP; Tue, 8 Nov 2022
 04:51:33 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <fofoneabraham@gmail.com>
Date:   Tue, 8 Nov 2022 12:51:33 +0000
Message-ID: <CACQYsd_86EskwgmAn-0JzC49VxbKQEPUKAZn2JUhgtSEfin-qQ@mail.gmail.com>
Subject: Greeting
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Regard, Mr.Abraham
