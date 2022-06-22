Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28FA554E2D
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jun 2022 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353349AbiFVPBf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jun 2022 11:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355512AbiFVPBb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Jun 2022 11:01:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DE53DA4A
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jun 2022 08:01:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h34-20020a17090a29a500b001eb01527d9eso16224573pjd.3
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jun 2022 08:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=vhZEVnaGNBjosB86GDUW8b2wHjB/+QU31bPXl36TqFE=;
        b=GeAai5ggL5ED27lapUlubyV5RKczyzZpKFmASb2DELt1Tsg1Hpx3AsjZ45k5Wh2r0L
         WtO1eFPFAkbNauhRZAAYFQKX0glbJpJV0ZuN2qf3eGc0asDtBWLn7mlETudubSEP1hnk
         NzcphurocGeMVlgpMLj7PUR2eR2Lp4h0JPRERHFBD8Tzz7X3sItnn9hGT8tybK3nvHmu
         t7uJVXVuf++/i+LsLQofdhOugkpS+2A5bnPZKH+n/96kCACuHra/CmVK6La9AmBpIh1s
         kC+2Nb1mHCluxmPl5JsheR6qW19Vdo48bhW+ijXOdK693c2Npx/Hxx3uAp0LkN4B9CXZ
         kHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=vhZEVnaGNBjosB86GDUW8b2wHjB/+QU31bPXl36TqFE=;
        b=NAS1IyPvq88x1v1HZAHkXjY5t1kvz8HauCCAnqhUpy43Ae+gvZbzAkGrerwMVQWmyf
         N31py8TVVrPQpJdkFsO4e3vaeyVfB6fuNurBSkXZEb4wvkelj6LNDEEJGHyyojq+4HgR
         ZYqFMPDdZuQyn3RY4rNJHMCG4iCRtGofAE7h337NXoos3hFUo7TtXgMLCTo4bedc7sNS
         oBGk1B4OKhJPL9fhotbthvi/lhdGuCtabvCuDJpBh1sjX/Y/OMaRP9yt+39Zfmfb9lTq
         jgLrGVkQuG29/Isi6buviI5+cmfqW4naeSW0cevBF3DtbHFFtMrIAtiSa/joicqqP1jK
         gN8A==
X-Gm-Message-State: AJIora+Yo2L9gRgb5g7cFJ3MTtXrqztuR7qZGWniTfFv1gAi+opN5wOV
        IvdokwGj/060WpSnhu/yKEoaD6g3LTM1WIhNnMY=
X-Google-Smtp-Source: AGRyM1vRS3SbnxGLdXB9F5H/43Ax+nASo2xXssBGr5RIUya7NECDwqWwkb6vZkRvKxeygLW6PQ8XL6LtYBAb1l5fJCM=
X-Received: by 2002:a17:902:d481:b0:167:770b:67c with SMTP id
 c1-20020a170902d48100b00167770b067cmr35097265plg.77.1655910090310; Wed, 22
 Jun 2022 08:01:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:903:2308:b0:16a:1b3f:f74b with HTTP; Wed, 22 Jun 2022
 08:01:29 -0700 (PDT)
Reply-To: sales0212@asonmedsystemsinc.com
From:   Prasad Ronni <lerwickfinance7@gmail.com>
Date:   Wed, 22 Jun 2022 16:01:29 +0100
Message-ID: <CAFkto5uqi1Qc=yzisU1KPGkp2KcGr60-08=33tyyW2AEWvHMLQ@mail.gmail.com>
Subject: Service Needed.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

-- 
Hi,

Are you currently open to work as our executive company representative
on contractual basis working remotely? If yes, we will be happy to
share more details. Looking forward to your response.

Regards,
