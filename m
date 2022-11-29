Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938A963C900
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Nov 2022 21:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbiK2UL4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Nov 2022 15:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237240AbiK2ULw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Nov 2022 15:11:52 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5115E9C7
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 12:11:51 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ml11so11614040ejb.6
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 12:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=legvGcKgmwLAMK4y4XOe/MwITozgdgtfyHeG3Kd+G99qcMNEQ2mbsZFO8njO+4iBKo
         puZe+5IR5hZuWNIE/QPaZpXAxcfz+4ifTezGwBi83xffaBF6FrpiCfindu1rplLnwxec
         UTSk3iVPPWTfcs5G1+0IlnyP5HnFyF4sdf7rhpW6bERbUZMv22yuIf99gZBfuf3v5jHg
         V1fuI9CUwj+3+n1XRLD3Ss/wvKC9NyXwzKFm1jBmbqtNCqC3SpCsdl6/kFiZRUneryLz
         13nfMdGti3nXpXcOORLWaOraD9rtlXXdA+98wpxJ+kM3T9EA7rxK3tDE+FFm1NcTv9l+
         miQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=k950zxlZt2idl4tdy5EE8XVpbtMHfiIF+fapv2/JcX/R+zLUPU44aSAYx0U85ij/ma
         227ndS/NCJS1bZ7joQ4hrw+SOZJYgV9sPHKTw20lge0OoxuEG3EVk6QGCgwd0lsXafvL
         IvXBjrbT82RdU1NTTRU257f+n+m8Sm/vCHnQd2Hy07FeMvMRW18+LlPJaN5llAO7dVBW
         secksFzcw70K4IpES37M1MchOTn8U8awTdrkSAq5bfsmy2CON19Jkx3DpbIF3vu21Y3Q
         zIjbmqJopw+srb+9NvJULe91ePFVOxKg/C3qvNaeBTSSVoJc/lyo59YKM4/1g9ZrYV5V
         Tj/A==
X-Gm-Message-State: ANoB5pnjE9bqF28uN3WGPw6VxUvNrFDzqHKrFqOp4o6mH8FhHXnQE9NG
        PGImPHnFPjhN/VDzEA2oynipsGiU08Hd5ZJTGEs=
X-Google-Smtp-Source: AA0mqf6n4eQhncAoUDm40s1F04NIWUFeOghviULUaNZk+okN/FBUf/6ix35VhVwVMgAbdOOpj27nrcrT11y8WhgFCo4=
X-Received: by 2002:a17:906:3a09:b0:78d:6655:d12e with SMTP id
 z9-20020a1709063a0900b0078d6655d12emr34556543eje.260.1669752709273; Tue, 29
 Nov 2022 12:11:49 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:8747:b0:7ae:e68c:886c with HTTP; Tue, 29 Nov 2022
 12:11:47 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <joykekeli3@gmail.com>
Date:   Tue, 29 Nov 2022 20:11:47 +0000
Message-ID: <CAKaeHTfQvAVuxhh9eS3K9RA6NdSD6Pk+w=fa1WJqh-H+jdHVaQ@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Regard, Mr.Abraham
