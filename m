Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FE56F8F9B
	for <lists+ceph-devel@lfdr.de>; Sat,  6 May 2023 09:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjEFHDU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 6 May 2023 03:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjEFHDT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 6 May 2023 03:03:19 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E375455B2
        for <ceph-devel@vger.kernel.org>; Sat,  6 May 2023 00:03:15 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id a1e0cc1a2514c-77d049b9040so17753761241.1
        for <ceph-devel@vger.kernel.org>; Sat, 06 May 2023 00:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683356595; x=1685948595;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=woT4Y6rZ5eMwziVdNp3BBHa5AlN1UvrqAgZ4Kd65IuI=;
        b=niBVqJ1nSnZmwp3HCb5i2n008AoqkKmygyTjmI9Hz8lRL2AMm2zVLM5f3gybBAFFuA
         B25ngxTOj3jz9kBrueYeyz6VM5qYuMj46R8YEdAj8sxrm3mHzotKywcMB/PrXm8BzrAe
         GIZLc9P0G4hdASA5fJh+R5GRRp02fD1kfE5Q8lwDMl7I4eJ1UFcAQujxV9bH6w4BHrSA
         pzZ//Kd+Xc/lcrYw4ObjgQa/OUQgzePA0wJ8C7w2ZPAxF8e6uKK8VIs7ODzs1cXabh6o
         Pi+duapJEtO17Qa5zNwH5+jp9pIhbC3qBJQKEre0SwN7/4EYEsbijAB5vH0Il/XS6kXJ
         ujDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683356595; x=1685948595;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=woT4Y6rZ5eMwziVdNp3BBHa5AlN1UvrqAgZ4Kd65IuI=;
        b=S7xHfwlOtVX2f18wYA8t+Y0jlj4YmxHDdmSSRg5ZrjsGGYP0zomyA9CKdGQ/ZTFQ8+
         TpwPy95FgaajU+2Kc4v+jR6zZLTcoe8XqbRZlxZjojs5//w9n4tlIn4sqPKRJRlrnmv+
         ptQU61RATuea/9IoOFSWbvyNTuMJdXC5Yqja0ZRmnf420Lpp7YkOu4si9DBOZKBKud8t
         VnEpb4ep1ZyrRL1vdCHi2AUWjYnhRi8RlOZl/sJYQxxi5Y2Edd1E/2+Qt6rNG5oWoHO7
         x+i+rmJNew88iz5udI77ElgTiwyeI7le7RvNU3SG/Hk7J0aaXUI6aVxUAVMvz2lzS1jC
         Oj0Q==
X-Gm-Message-State: AC+VfDxyKw/9E+d8D2wUIF4CE6gfUOXp4uB2BhUqtAxtIDgd6TTlxmT5
        u29Hta6oulmeUX6QpPUCcG2UsaDtCZBugFzSzCQ=
X-Google-Smtp-Source: ACHHUZ5D278FWzTxQOuuwc7xbmV6Ip9hv5bZSZE5zv36JRsn/+ou26pANXSNEdN4xmflFSHyJRtj9nuw2UpYea6xtNA=
X-Received: by 2002:a67:dd11:0:b0:434:859d:a91c with SMTP id
 y17-20020a67dd11000000b00434859da91cmr514559vsj.9.1683356594781; Sat, 06 May
 2023 00:03:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrs.patriciajuliawilliam@gmail.com
Sender: s.nathan545454@gmail.com
Received: by 2002:ab0:71c2:0:b0:772:a214:a01f with HTTP; Sat, 6 May 2023
 00:03:14 -0700 (PDT)
From:   "mrs. patricia julia william" <mrs.patriciajuliawilliam@gmail.com>
Date:   Sat, 6 May 2023 00:03:14 -0700
X-Google-Sender-Auth: 9Ihs54zwa7s9jEqESTFfASjYJjs
Message-ID: <CAEWeV4H3KEcd6_gssaAzEjZNF9CxFHXu0_6RL2SE-=2+sGq2oQ@mail.gmail.com>
Subject: Yours sincerely,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Good day Dearest,

Mrs.Patricia Julia William, from one of the cancer hospitals here in
America suffering from a long time breast cancer of breast and i want
to donate my money to help the orphans, widows and handicap people
through you because there is no more time left for me on this earth.

Yours sincerely,
Mrs.Patricia Julia William.
