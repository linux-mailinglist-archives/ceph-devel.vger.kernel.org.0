Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C468B63950F
	for <lists+ceph-devel@lfdr.de>; Sat, 26 Nov 2022 10:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKZJwg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 26 Nov 2022 04:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKZJwf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 26 Nov 2022 04:52:35 -0500
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C7B19A
        for <ceph-devel@vger.kernel.org>; Sat, 26 Nov 2022 01:52:27 -0800 (PST)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-3704852322fso61639437b3.8
        for <ceph-devel@vger.kernel.org>; Sat, 26 Nov 2022 01:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aDnRL1ZmQxOMFMNGZoJPqBH20uB7idv9vdFa8r24GwU=;
        b=DycAHx5gVrxrmgREeKcjRo5xFv2GIx7RXCF8/QbDjRka3ED1zLJbLZSE1cyC/ocMn3
         5K6sxXJsk9uElRFwdC47K4l78qlbwDblJGp/EtjjKA06R3uXouevRrTIIbocUevmQVH/
         hPFn08sEqbUYsBlEi5NqqO/kTU74ltj9YzLAK8kw4nA7yjm0Z/upmK8QEpxq2bBqyefH
         4z01TEcv4QSYI1jQlM0/sAAwFVTgX51Nchzt4rDQES4AuZ5n3iJLVpKG6wXVMoyzlOWL
         lb2qRF/rJoziEb+M5Nusi5dfGWTXhMu8Clwti10VdPKvcE/I7l9EAd4gtDAHemABJTIZ
         p+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aDnRL1ZmQxOMFMNGZoJPqBH20uB7idv9vdFa8r24GwU=;
        b=qGAu4iMF2TVJQ5UUcmv8JMoAVFnHcsie9Xq5PjUN1lvI9SorqbzfymoXf6WNg4qjJc
         O8VFeBq8uhUE/p63Ccn0Lhop8oMELHycqSm7zClaIsuCW/XpglbKsHYSlb9G2QZAmt18
         RN2UCeHokPhdMOQvB8sk5nTPs6vLv3Y0yTBKOaj4FJdLH/CetT23y58hNzWJ+oyqaKPB
         +PvJ22UXaqRzCnGlD1JjOFP95XL0+ktz4QqvvaTQyoXvg6AOLDpyCqqHxrMhJ8qph3EY
         GFmdaJLfTGj5mTRZ99Tji2EMm7A1+X3LBxPXpSNX/FYSQPpsLlYPJlkex+j/XoLRmY7l
         KplA==
X-Gm-Message-State: ANoB5pmLeyfakzmL+EoKfboy1z6IFmhzLd2Yl0JKpVA8Lu+RgViceMb5
        jrQg8fzwepdljg8UtIW4OV4zc7A8rXujC9DSJkw=
X-Google-Smtp-Source: AA0mqf6XvLJvNZENvJK7pHbwQFOePdhG+SBY7kcRz9cTyaEx1Firc23bEKnj8dT5JkD9QReNegnIZ8+kDphjYHUZrv0=
X-Received: by 2002:a0d:d80e:0:b0:388:e4d6:dfa6 with SMTP id
 a14-20020a0dd80e000000b00388e4d6dfa6mr21809890ywe.216.1669456346871; Sat, 26
 Nov 2022 01:52:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6918:30c8:b0:f4:f601:74b6 with HTTP; Sat, 26 Nov 2022
 01:52:26 -0800 (PST)
Reply-To: ninacoulibaly04@hotmail.com
From:   nina coulibaly <coulibalynina15@gmail.com>
Date:   Sat, 26 Nov 2022 09:52:26 +0000
Message-ID: <CA+8Vp3VL0=UKzycyjG=2PavK8KMC2_gYtKw8TRecf0nk+v8_hQ@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

-- 
Dear,

Please grant me the permission to share important discussion with you.
I am looking forward to hearing from you at your earliest convenience.

Best Regards.

Mrs. Nina Coulibaly
