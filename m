Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C12E52C5CF
	for <lists+ceph-devel@lfdr.de>; Wed, 18 May 2022 23:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiERV6j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 May 2022 17:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiERV5x (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 18 May 2022 17:57:53 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6BC17CCB6
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 14:47:49 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id i20so3082916qti.11
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 14:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=675CvuSp++zNLeIUZybBsP51nvc83dY+2bSGb3FYErQ=;
        b=qMY2ttAN8SkJzX3cZ1nAdkKN0qtZ1EoF3MRfKVJa2bV+Of45ZaAlzHnFa5EzRmiVfv
         jIZVPZbX8UUPiiZ0vzLpQcgaR5y7ZRUoHvi04H8V+Uuak8N1AFEzgt5iiXONjFbf/xhS
         F9ga7rGK7ZjYEpxvZ+RxIuHNUgLhKU639SDfkZuuqs4ZG+YgXmGQlogL/bVnFv9Efuuo
         afQEkH0lXj/yYkPrXBYGWhU6LaUJwPF2bCs2PSRNwARFCMZC5/0XBeolVp1BSVKknWJg
         /uK84tM1Tzaanrb/IH1Hw0t3oFDSRLzCBsMvZmKn3/ssKn+jJfPcf9hYEMxD6+A93cJm
         ylCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=675CvuSp++zNLeIUZybBsP51nvc83dY+2bSGb3FYErQ=;
        b=gXmvGNp3dHKYqma1kfjXu5/gkEY36/jTAFctDq+i6hEfJX2URM8QC53VHcWpT3xUMv
         6iA18/eK4qMEt7uFrSeoZcXcuJP0qGt4DehxvLgBzOfHKCA40aHIAUQQb8Wa1+dArHsU
         KcuurWOyYESv5x/OVOuKwORz+pxXwgRth2aVvvQ7XM5zl42TXSOaD5GxD5Upb452vMY8
         ILC3ZtAmwq1xv708AME6PVf6qpkC3j2T+qr3Vm4FJ/xFfJMdePW1BwGoxrl/SBEVFpX+
         QEpxtHePsjP4/Wmytl3SoEvvfuhqhl2SHyhNk5DDSp7LfvuCyelHP2+J8119BFt+2Z6A
         QnqA==
X-Gm-Message-State: AOAM531U8+ZgAwIiabQgUH6L4nFy3ELGtUY0DCCGdW++zXc5Hi8+hph/
        J6/6myWjdoljfeH8iNy9MlHkaqqv8vAZeP89Cd0=
X-Google-Smtp-Source: ABdhPJwfT73T7r6tjb4QoLeme6e/aRtdUOueufrGNY3SEn4kHVTz68/lzXFzVpWeonGLBEdh6k4twgcyYPxSKF/PmfQ=
X-Received: by 2002:a05:622a:58a:b0:2f3:c0d0:1def with SMTP id
 c10-20020a05622a058a00b002f3c0d01defmr1663175qtb.78.1652910468959; Wed, 18
 May 2022 14:47:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ad4:5cc1:0:0:0:0:0 with HTTP; Wed, 18 May 2022 14:47:48
 -0700 (PDT)
Reply-To: tonywenn@asia.com
From:   Tony Wen <thompsonmiller942@gmail.com>
Date:   Wed, 18 May 2022 17:47:48 -0400
Message-ID: <CAN7gJ1T76Kd+02jc4pErvxVS6hbxbf75pPhXc5xrbAhncL+TKw@mail.gmail.com>
Subject: work
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Can you work with me?
