Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7BD767C14
	for <lists+ceph-devel@lfdr.de>; Sat, 29 Jul 2023 06:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjG2EVA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 29 Jul 2023 00:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjG2EU7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 29 Jul 2023 00:20:59 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737AD49D5
        for <ceph-devel@vger.kernel.org>; Fri, 28 Jul 2023 21:20:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-2683add3662so1880015a91.1
        for <ceph-devel@vger.kernel.org>; Fri, 28 Jul 2023 21:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690604458; x=1691209258;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RE5l1VpxCufAhFhvUtJmOdSBkyXi7tvoVHorDEIVEKk=;
        b=eTKPFzDVlCVCD729YC/fNARpxPKJmbcKPJ5PrqHLuFkrQTAnFQX5I9vYbnumWFLxo9
         LfZmeokE3Nvt6VZqUeB2mVqDIQPPUpj8h8K3Ib4HIgsBmxnKIjcMl5R6fZnP9pbv9WIb
         fy/60rGbGHnw+fNoIRQM3Lgo7qLs/VNO5ld/sxEwIFpoUnmv3X1eZJj5tN4xlEVhfMO6
         5HgtxBuBksxWlh3i4kyh9DjYnkG84wtUIZ0LG15o+cZ8qiNqiCTBabazN8lOVZMXoL7g
         1Lic4c4THtv68N/pvhNcezlqoFZ7kZk67/blS/OBK2g/aj/oeyCm9oAW1+hJlS1tWglT
         7TWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690604458; x=1691209258;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RE5l1VpxCufAhFhvUtJmOdSBkyXi7tvoVHorDEIVEKk=;
        b=RJbVFJGHkgbZ2P12khXvpORTPri+tH9b7utu/AeSUm7ZLnBqGTmrKV3pvhrBXe/WKl
         CS46c63+fq7lBioVFdsU1zb21CN1KfhqUq+VWruWJ05taNNvuQ5tb71ZhzGo67jkj5in
         8JI3ZWioFYHsjeClZF9gSHusxlzwDLxl3R1F1UqBIRoV9N+4597QBdP2PSjPwmNPx7Oc
         n8/dVfZaNcwdZ6aNz82ZR4+eGaMOPU3D/rIy2+ID6SyoFUGC0VjSFKSUlpdPHDs/srHA
         uwW+r0zAjJgZfgPF2QK9lgfjqHLrLOroIqXsbXCcHv1/mTuW3LcDMbSLN6UivDj2pvYb
         bwxw==
X-Gm-Message-State: ABy/qLauP8fqlM55Y1et2EhBcPEbcFVimK3YxGDlY41KiszVR/gavcgH
        n0gFfY0BXoA75Ns5BFP8KtKKuZXP0X8j2YAKkQA=
X-Google-Smtp-Source: APBJJlEzDUVH3bG0XLXttbNNEQmE5FQiSuHoieI5nYnbFR4cDbVY6PWgmr14GPXLmlGOQBeqUBCh7/4Efx5Q8JuBcNY=
X-Received: by 2002:a17:90a:fa54:b0:262:ea57:43f with SMTP id
 dt20-20020a17090afa5400b00262ea57043fmr3613209pjb.37.1690604457724; Fri, 28
 Jul 2023 21:20:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:7b99:b0:d3:811f:e55d with HTTP; Fri, 28 Jul 2023
 21:20:57 -0700 (PDT)
Reply-To: bintu37999@gmail.com
From:   BINTU FELICIA <felicia712@gmail.com>
Date:   Sat, 29 Jul 2023 05:20:57 +0100
Message-ID: <CALG3m0FrePQqaPEgGCPFtjcfBHrGi5LrsgaZ9VUECQEccx_UrA@mail.gmail.com>
Subject: HELLO,.....
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

How are you today? I hope you are fine. My name is Miss
Bintu Felicia . l am single looking for honest and nice
person whom i can partner with . I don't care about
your color, ethnicity, Status or Sex. Upon your reply to
this mail I will tell you more about myself and send you
more of my picture .I am sending you this beautiful mail,
with a wish for much happiness.

Warm regards,

Felicia Bintu
