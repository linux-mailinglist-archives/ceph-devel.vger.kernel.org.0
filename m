Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE465F8A95
	for <lists+ceph-devel@lfdr.de>; Sun,  9 Oct 2022 12:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiJIK3L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 9 Oct 2022 06:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJIK3J (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 9 Oct 2022 06:29:09 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3744D2A70F
        for <ceph-devel@vger.kernel.org>; Sun,  9 Oct 2022 03:29:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s30so12422869eds.1
        for <ceph-devel@vger.kernel.org>; Sun, 09 Oct 2022 03:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XTr38ZW1ECJLL9olNzI7vWZaLATSkyoIyaKp0D1jcGw=;
        b=Y7P/MvloAmyFv6+sWjyZI9PowznTMWKeuQSu1mT95VhTw0L5Sle+A/qrd4iwEtIy/S
         xIVoot4pcIpaAS+PP72qxBh9fYkV9BHceUR9IYNNq4pCPFPfOhxWiZbuHFltHrcF1fNv
         76xOnHc5AVqHJSWJ8j2OUfMMQ1B5aI54m7AzilyzZePFEqdn6OjZXyFWLZT2/ccw5Evo
         RkC7I6S3CLsKsFALsLLQRQ4oZ6UZ/o/3yugIRYr0RC8NydGh4OSpkSCEao5diuNF87xV
         8cUvXrjuhnh6v37Rp3VSGY2sE8PzKBL4t9lpyUQVaaHjJ59O2nH7YojbarHWVQe2TFon
         SAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XTr38ZW1ECJLL9olNzI7vWZaLATSkyoIyaKp0D1jcGw=;
        b=FPOc5QCcQnl0dERA639DZ4PcOPL+nkp5ucZ4SaaZSLae0I2UyX7ynm5+Q9GCz2T67U
         eRUqq7nDA1SxlUsJFm9sGTpvOS7dWqxDtOgxiX95kLfjlr37uDHr0+E20XWy2mkUc1kN
         AwKASQRuduQp3XmKqhs/7dy3t0Ba5QkcoMl8OFef3qNIoFA/Hzg8MNUWnR42y1FpGz/p
         Zc/nPFdeTgCAbpbDb9pNrd93+Y3vhthV4wgHw01wz7kXh6dAaCt53Ln+zpK8KmqTHNwk
         iQUSEfyuhm05BTRRTuC8BNw9QgAhbwaQFrSdmKwodBot0CQr3JQg3X+emHiadnapAR1w
         v4gg==
X-Gm-Message-State: ACrzQf1LVulqlcSDuX3iURBw7s59+NHfajAizwtV+YWhoLVrsh7Yoiut
        Vw0kN+WK3UUupmGREwowKtlownB+T0Nm6IcJir6fsg==
X-Google-Smtp-Source: AMsMyM5zFL4SWBhm0r9ctT/JMEWEjl9IofNoocPqbjhVkiKbeNux6JCZmVQFqD6BGMbT1RrAGEVcficbNrqRZBK9wk8=
X-Received: by 2002:a05:6402:4003:b0:459:b859:ed09 with SMTP id
 d3-20020a056402400300b00459b859ed09mr12609345eda.135.1665311346806; Sun, 09
 Oct 2022 03:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220927120857.639461-1-max.kellermann@ionos.com>
 <88f8941f-82bf-5152-b49a-56cb2e465abb@redhat.com> <CAKPOu+88FT1SeFDhvnD_NC7aEJBxd=-T99w67mA-s4SXQXjQNw@mail.gmail.com>
 <75e7f676-8c85-af0a-97b2-43664f60c811@redhat.com> <CAKPOu+-rKOVsZ1T=1X-T-Y5Fe1MW2Fs9ixQh8rgq3S9shi8Thw@mail.gmail.com>
In-Reply-To: <CAKPOu+-rKOVsZ1T=1X-T-Y5Fe1MW2Fs9ixQh8rgq3S9shi8Thw@mail.gmail.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Sun, 9 Oct 2022 12:28:55 +0200
Message-ID: <CAKPOu+9A8T68_uHQLamMdkO16eDdhZAV=AV8tC=uTos5hGgZPQ@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/super: add mount options "snapdir{mode,uid,gid}"
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Oct 9, 2022 at 12:27 PM Max Kellermann <max.kellermann@ionos.com> wrote:
> I know that, but that's suitable for me.

Typo: that's NOT suitable for me.
