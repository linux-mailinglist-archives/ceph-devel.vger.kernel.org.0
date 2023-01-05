Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D706365E97A
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Jan 2023 12:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbjAELBu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Jan 2023 06:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjAELBR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Jan 2023 06:01:17 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2257F50E7E
        for <ceph-devel@vger.kernel.org>; Thu,  5 Jan 2023 03:01:16 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id g16so29325371plq.12
        for <ceph-devel@vger.kernel.org>; Thu, 05 Jan 2023 03:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=agencysonic.com; s=google;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jMPeVdVw0BvFdT1czFRYHv4p6/nusLoyjLFoWIDBzbg=;
        b=D0JK33LyBIHI5KlDV5NfG+tUa9D0AgvRwJVUlCnOO+NdMVrxNFoLFyzDyiLNoPcJt6
         N/Rakc5msmT20CGl4WEQ088IDFAtFeGa7yiF5GLB7md+gJkAOM+EPVnzPv/uwkWbmoz+
         DKnBWXJhNS1LWwW0++Fqne6tA4mt+aPS51Ssn49wubYXy6cMNcaL/mz2LOVkJB/k+kQN
         oIkis+GmcvX0groLu7G34RVQemUm+MubGXZrpaYDdlxEF1UvxvXrUe2uhy7v5jrLB22+
         mBSZfsvUBUykkvY2h5vgvDLonIH/m6NZRBENb9pLH/DcjIIIEsLqYRpIFPIPqkwVmSDC
         MhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jMPeVdVw0BvFdT1czFRYHv4p6/nusLoyjLFoWIDBzbg=;
        b=1dcvz5i+sMkOMKbP90WgXF5eG0EzuZvHkx9bjqEIR0El318AyAflZjGa/YP+KGUK1t
         MpGT9FL6CUGRno6jRj5X0UK9JLzV/XLz7VR8y+gJbf8K98YnYZlgWoXksbFAbU1xS6Yh
         p7VxflNrXL6Mm8/52YSSWahoQbGJo226sGkgB32jUvtLtXSFQMx9PL76E7LXRM0X5flP
         c/xPRZ3jQPDRRxzDtBqUemKX+gUFcEiDStCzlICmoZb6GTytkX6nbqa76HVhpyrzmerK
         eXdMBOT6I4v5zRTZr7txsyiMv1S+gtm2yo/aEZrMgY6+eCVHyRzuyyZH/yr0/tX1P4tU
         ajFw==
X-Gm-Message-State: AFqh2krH1r9zIMp46vzGk1gJwOOMIna8c9XZ30NCVFWvEda38n8hZw9C
        RZz5ICWbDWi7S0i/KYZeFLV5f0R6VO+mOrOw4ukHwQnbcmaQnDCgMdr9uA==
X-Google-Smtp-Source: AMrXdXtZlwv25wHMP2pe40hMyfk0rUZftwcMwetOLN97NefgMkpZEFXMEV1sFN/C23xotlMPmQpnJ5b+IHKzQfllymw=
X-Received: by 2002:a17:90a:bd0e:b0:225:cd98:1651 with SMTP id
 y14-20020a17090abd0e00b00225cd981651mr3630730pjr.93.1672916475296; Thu, 05
 Jan 2023 03:01:15 -0800 (PST)
MIME-Version: 1.0
From:   Office AgencySonic <office@agencysonic.com>
Date:   Thu, 5 Jan 2023 16:31:02 +0530
Message-ID: <CAFPuWw2aLmvesEMn6zjF-X4HfB5ytJLk36paajV-eb4D4gU7Kw@mail.gmail.com>
Subject: We want to advertise on your website
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

We have a client in the gambling industry who is interested in
advertising on your website.
 https://ceph.io
They are interested in a sponsored article or in a homepage text ad, as fol=
lows:

=E2=80=A2 Sponsored Article: An article written by us, published on your
website. (Including our client=E2=80=99s do-follow hyperlink )
=E2=80=A2 Homepage text ad:  A small text ad with a hyperlink, placed anywh=
ere
on your homepage.

If you are interested in our proposition, send us an offer via e-mail
and let=E2=80=99s make a deal!
Best regards, Derek
AgencySonic
