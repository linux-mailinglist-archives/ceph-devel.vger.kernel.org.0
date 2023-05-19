Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84777091C1
	for <lists+ceph-devel@lfdr.de>; Fri, 19 May 2023 10:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjESIgo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 May 2023 04:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjESIgn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 19 May 2023 04:36:43 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDEBE56
        for <ceph-devel@vger.kernel.org>; Fri, 19 May 2023 01:36:42 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-510d8b0169fso3789755a12.1
        for <ceph-devel@vger.kernel.org>; Fri, 19 May 2023 01:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684485400; x=1687077400;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYlqmqzmZQIzuckqyml+D+cUQfB/LAmhyfGQVjeCZAE=;
        b=WkyYt7QM2A4XJdCG1fcX2AjCUzAb1DD8FmnSnqTeShMOLoTZQuN1iy7bgNhNLPke1o
         BSh5FfNZrVCaoFWuud/HiNQBBcSKRsODQQL8qJuYka0c7FgQmJtp+5LjLRn0Obkt0NSr
         1CtHT8SEp20BTc1CiBKpRaRO8MHPiP+XD4VJqHp3AHyiFsBeRxT3L1jm3SvTP6DVO7l6
         SanKMC5isEGNaq90GQNvswNptDMpsO+OARifz1qQFzYO7iSnMKJNk8pxKke64qQQVSAA
         tOawGo+bccw9ge59Ru4Y2kwu5w5Qkx7HVuVuEwLjWhxrNwUg94WrR8IBekG3XrzYLpPy
         4sNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684485400; x=1687077400;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYlqmqzmZQIzuckqyml+D+cUQfB/LAmhyfGQVjeCZAE=;
        b=SJQzQ8KfNHFGBKRX4cJudrAmpuiiZzeVh3oxfx2rQ6rd4OSe9L4ytV8H4QE0/iNaaf
         ei9DOIa0+JWG1t/n/mA7GQuSMTzedVXl225525BIqkVyiiAmSH1V3ARL3uz2YhZXGQ9X
         8iAcx1sh+qjsaUl/+SX4pzECRrbldSj2pT6RyzIaM/wNI+WKg2DYhl4dPT6r0gkmnvFB
         3PUj87dURsGc+9nXGnqAtCnbC0nHdoYgG1h8NuZwNZ8mR4XwGpLs5q6Hoq1fPgVwMvhq
         UwVreNUIGexIlPj405/l7jaGCxvVq1IVFUyuH/OkC8IKPmZYulFyRv6NGIDFDJDK/b/x
         hr4Q==
X-Gm-Message-State: AC+VfDyFE9T8cYBl4DG2oD1/UrCfBWmkweiJa1TA3liVjB9nErlXyTws
        BPwIiNvFOXz7pyErKKvoQnAM2NEAqn6YjHrRprI=
X-Google-Smtp-Source: ACHHUZ7uw52qpsxeUuXpvmmOKEC55lFEyS5Wy/0ygSEE6oBP4SVDYJHAcZWt263W/q2nC9Zo07/aXs2YHCU8RFZty2Y=
X-Received: by 2002:aa7:cccc:0:b0:50b:c0ce:d55 with SMTP id
 y12-20020aa7cccc000000b0050bc0ce0d55mr990207edt.3.1684485400435; Fri, 19 May
 2023 01:36:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7208:4054:b0:69:6979:70f7 with HTTP; Fri, 19 May 2023
 01:36:40 -0700 (PDT)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <ninacoulibaly79.info@gmail.com>
Date:   Fri, 19 May 2023 01:36:40 -0700
Message-ID: <CAA+U+NKR8Zbm7D=cjXQDLtv+A=42nkArQwEEQ9mT9pYQUxffDQ@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you. I am looking forward to hearing from you at your earliest
convenience.

Mrs. Nina Coulibaly
