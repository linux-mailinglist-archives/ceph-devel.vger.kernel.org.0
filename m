Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AF35B7C6A
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Sep 2022 23:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiIMVCj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Sep 2022 17:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIMVCi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Sep 2022 17:02:38 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1506A489
        for <ceph-devel@vger.kernel.org>; Tue, 13 Sep 2022 14:02:37 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m1so19337394edb.7
        for <ceph-devel@vger.kernel.org>; Tue, 13 Sep 2022 14:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=firstdatalist.com; s=google;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=NpNiigzfmaHvFlpw9yIRuSCLZBMN9I4gPi1Nux3DTxg=;
        b=W5Yjn2joypetvWev9eahM2RbvmoNysoAihtpnR3X6x96LNKJrUdAZURJFTHNvn8mCT
         b6+7GsDDE5TjpumgF2maiFmE03Iw8pLeevEIUXnY8S1dgf0EkgqmcGF5BOwb/psBYcEm
         nENTFP07V9XtGDiQrPYqGxDUilFuuPZUUh2bLT9iF5k2Ee0r5YWyltQk56oOIzalT1HQ
         Hpfhmdwp7qDqKchr3TOAk03yfbQDrH+T7siVBqx51rZspsg63eKMTXIUHL6YggVc5zRt
         Aya1oF2PW2HC/Wwm3xMXdOfyJqROTodb4fYXysBGsnZ4BnxA/nHyr6RPqwE7ij4fO9mc
         VRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=NpNiigzfmaHvFlpw9yIRuSCLZBMN9I4gPi1Nux3DTxg=;
        b=3c9/33MdcBkYvYNuHODNYUfbkMCgJj+o6uJtp5idivvUuw2MeqPX9UHQQxqFzy6REL
         5oVKGHzY+O3+JawK0kOG58WgDNgsMOLQdxop84csXV8yXZqQp7xYZ2dERrSAKpEedMVO
         bSipAIxoqPtJVkgjg1H9G8MFWGAytNYzbGCc1Cn1s0s3enr+hHVjfKSocXTU0uB0Utio
         15kv46ePGcHnv7QBrpYrbYhNeg1Ocd6Tgk+ty+GLbFrvOveV0fGsc+9J5u8E5x2XvpGE
         IC5tzMPOqN1lAIbfCS8bUeTAUT6rIjWfqOGN621n1obtu0kJ/GxzXLO+vLT8OaQLA9TX
         cI3g==
X-Gm-Message-State: ACgBeo08fMwUf/9GGkkDtUDS7I8JB6hWF0us4u00YLn2bxWYzzUdwx/i
        +jGo6S/80Aljt4Dh6rDjHIM67dSYirtUWJVveg/Dnw==
X-Google-Smtp-Source: AA6agR707h3tHUwHGCGHUiWkv9os1XONjEM8TmLIukADcXVvGm+PX8PBNBzdXhXQ8Uw97+PiMIV2sEdMwM3vwBkvQEA=
X-Received: by 2002:a05:6402:1ad1:b0:44e:8dfb:2d04 with SMTP id
 ba17-20020a0564021ad100b0044e8dfb2d04mr27336829edb.400.1663102955660; Tue, 13
 Sep 2022 14:02:35 -0700 (PDT)
MIME-Version: 1.0
From:   Sophia Jones <sophia@firstdatalist.com>
Date:   Tue, 13 Sep 2022 16:02:24 -0500
Message-ID: <CAOsfB8+sre+xfG3GWe87u_pgQ5fq3qmiLgdXz2S=iMNgRa6wqg@mail.gmail.com>
Subject: RE: IBC Attendees Email List-2022
To:     Sophia Jones <sophia@firstdatalist.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FILL_THIS_FORM_LONG,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Would you be interested in acquiring International Broadcast
Conference Attendees Email List 2022?

List Includes: Company Name, First Name, Last Name, Full Name, Contact
Job Title, Verified Email Address, Website URL, Mailing address, Phone
number, Industry and many more=E2=80=A6

Number of Contacts: 40,968
Cost: $1,826

if you=E2=80=99re interested please let me know I will assist you with furt=
her details.

Kind Regards,
Sophia Jones
Marketing Coordinators
