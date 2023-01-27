Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F070267E109
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Jan 2023 11:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbjA0KGb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 Jan 2023 05:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbjA0KG3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 27 Jan 2023 05:06:29 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6018F37559
        for <ceph-devel@vger.kernel.org>; Fri, 27 Jan 2023 02:06:28 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso3043023wmq.5
        for <ceph-devel@vger.kernel.org>; Fri, 27 Jan 2023 02:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=FJsJcmUgZqIoB36gsOSTmmdia5eFozJZiIVsgbCjNZ0byT0XdzUc8qiXU89etQWM7h
         CekbH2anXWT/I4oBrGoMcF2szQiBe+xijlGrK9XlR586xzN/Bwd9Sy28+oxcyk0lpcJ8
         ro2683TF/M89VDeDdQd7AJ9CBqs9ko6yRoj6rni2bINtknDDsH+OLiLQfg1CbytwibJF
         +7dJNfbjtaaaq70uev4tsS8TkB5fTVO3h6LhnzMt0jUerMy/fzPbYYEPaR0pS+4cUs8X
         IxnxU3RfOkiWhthv7l9COTkls4IR39o2aVZRwZxFoix6VYgHAAvYrgzDEzaGLp0ylW/A
         kJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=1H2LsbIxO9TcCnwEfObpbSQkBATBTSpKYuIQTU1Y/2KMzn/dj/Oe03Dk8iCLt2NuA3
         H4QCT+TCE0nLi0E3KDmTETsr5SDxLv9gr6wfFmik24UK9ujj662BaheWEnlFY4+NzKm3
         dt6GLexDH++rmAGEcCXueHy3VzA1DvO8AcNZrNMIuZOCoPsdp08rYExWxHiCK2h7TDNl
         OyIUeIr2s1gUq+U9XY8ZL43FpQVIbOAo3eaDo1vk0UKP38aJf8ZKSdi0pNyQHycUtdhX
         GoE4ZgLAKjR8M4/IBRNbNTDrL5GobRg4mzz6QgzZZ2Ihj4z7kTAtA8gHvva2B5hg8OPQ
         9Jew==
X-Gm-Message-State: AFqh2kqSfzZ8nLT2vKluxmCFZc8tEwRWvPuK1gs+a4qBmKzgQfdSS52U
        h29KMKKmhWEVrQwwRRdnKYQBAw8wS/UTLjL8Bxg=
X-Google-Smtp-Source: AMrXdXsXy1JUQSj4V70VL6fPUjuK9uz28/czzwT7a7ohGZdI5g+VRlhhFFctWBhh8Pv3nV7VjHAAhcuWARlVvCjFODA=
X-Received: by 2002:a05:600c:538e:b0:3d2:3e2a:d377 with SMTP id
 hg14-20020a05600c538e00b003d23e2ad377mr2808683wmb.118.1674813986377; Fri, 27
 Jan 2023 02:06:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6020:c602:b0:255:a993:ab07 with HTTP; Fri, 27 Jan 2023
 02:06:25 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <harikunda7@gmail.com>
Date:   Fri, 27 Jan 2023 02:06:25 -0800
Message-ID: <CALNCe2Q8zV23kOaoE1P_1aS_NqV-WT4d66yzKhrgbiTzegWGYg@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:332 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [harikunda7[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [harikunda7[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
