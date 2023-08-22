Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F154784B87
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Aug 2023 22:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjHVUik (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Aug 2023 16:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjHVUij (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Aug 2023 16:38:39 -0400
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 13:38:35 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229D4A8
        for <ceph-devel@vger.kernel.org>; Tue, 22 Aug 2023 13:38:34 -0700 (PDT)
X-AuditID: cb7c291e-06dff70000002aeb-80-64e5045c3d3a
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id CB.54.10987.C5405E46; Tue, 22 Aug 2023 23:54:20 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=b9osrGICc3cW5ihA4hVd6ulPzw2RwGl8tZGWm2pvv75Cx0y0byYIRcbFIfhyx6Tso
          H0WcgV6O4uE2Zwv9kKPDbXDugfHNZU+bzKayp3/HbHwr+ezz6GlKE/w1InwqilckK
          nOlKo9kU/xpad65Va7r2OpR81RqBAdKWVCnfZr+SM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=NUtRAh/hemQC7T6IaRoKPIGWV/pJ+ZbtZYspTvZY8/uD2F7b0BfxYTBHLSoyVokOH
          l3aWNfBcZjMlbMIaCMPNBEotWNRkkNWClO0bwbtXgMRjz0lTWLMe/v8E4ig1+/iMs
          +OBM8SUhhPBqO3wRT6m5QSqkX5BaEEftZQT16IWeo=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 00:28:28 +0500
Message-ID: <CB.54.10987.C5405E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     ceph-devel@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 12:28:42 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVyyUKGWzeG5WmKwaYjOhYfbk5icmD0+LxJ
        LoAxissmJTUnsyy1SN8ugStjyboLLAW7mSva+hexNDA+Zupi5OSQEDCROLxrJksXIxeHkMAe
        JonVm2+zgjgsAquZJU4efs4I4Txklnjz6QszRFkzo8TkjQeYQfp5Bawl1jz/xgZiMwvoSdyY
        OoUNIi4ocXLmExaIuLbEsoWvgeo5gGw1ia9dJSBhYQExiU/TlrGD2CICchIHt80Cs9kE9CVW
        fG1mBClnEVCVuDvbCCQsJCAlsfHKerYJjPyzkCybhWTZLCTLZiEsW8DIsopRorgyNxEYaskm
        esn5ucWJJcV6eaklegXZmxiBYXi6RlNuB+PSS4mHGAU4GJV4eH+ue5IixJpYBtR1iFGCg1lJ
        hFf6+8MUId6UxMqq1KL8+KLSnNTiQ4zSHCxK4ry2Qs+ShQTSE0tSs1NTC1KLYLJMHJxSDYyF
        Xp9y1DhTf872dN7hPTvhTVSZ8LJNM78HnHPat9z9vHKG0JIopaPm4j82M2td7ns+d56n1VFZ
        kWQdjTuPy+4YM4dbcMQ6f/hn5/xC/fLXj066/ObG8Vff39VQdH9sE3vmzuzkHSpcVlnPq4SY
        s80S1vSuTd+n3LjgnVCcROkOCdvfd3QvJCmxFGckGmoxFxUnAgBhxlc4PwIAAA==
X-Spam-Status: Yes, score=6.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_SBL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: iesco.com.pk]
        *  0.0 RCVD_IN_DNSWL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
        *      DNSWL was blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [203.124.41.30 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [94.156.6.90 listed in zen.spamhaus.org]
        *  0.1 RCVD_IN_SBL RBL: Received via a relay in Spamhaus SBL
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China

