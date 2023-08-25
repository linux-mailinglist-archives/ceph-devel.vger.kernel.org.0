Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357A4788144
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Aug 2023 09:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjHYHwG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Aug 2023 03:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243277AbjHYHvi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Aug 2023 03:51:38 -0400
X-Greylist: delayed 343 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Aug 2023 00:51:31 PDT
Received: from mail.corebizinsight.com (mail.corebizinsight.com [217.61.112.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD291FDF
        for <ceph-devel@vger.kernel.org>; Fri, 25 Aug 2023 00:51:31 -0700 (PDT)
Received: by mail.corebizinsight.com (Postfix, from userid 1002)
        id 0B49083AE8; Fri, 25 Aug 2023 09:45:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corebizinsight.com;
        s=mail; t=1692949546;
        bh=CEmchsDu5Oe+RNHCZSBmKSgMOuy1xnO2dydqkEjt3Qs=;
        h=Date:From:To:Subject:From;
        b=lCWWgFtreHi6p3/xhcg4SCXiNqtpO0EU7GGVbK1aHf6pWJKSv94CqjAmMaKK90D+N
         ctrzX3l3AmVXChjNMuuDsYe+SIAlr7plu2UjmKMEnsMMCVPyUUuIBMPOvnTWN20jcP
         gV038cF4jjEpzd0fcm+dtJRVdh0BgzmcpmKRRPM4ltQgXiyVUl5IPz/IMSBm1u3WP3
         ReoCSRbHUjmGBVA82hQDXkOXFabVRHQQmLHSZMb6H/LVxlL1LCjK0nHx68XJL3MLIG
         C2NDPPbW43/rIwHuKKBr1aHEVNfq01TrUOwOGaLCPrD2kxXT90tsuPnvvWlsYpSJi+
         vgl82VhFyTnow==
Received: by mail.corebizinsight.com for <ceph-devel@vger.kernel.org>; Fri, 25 Aug 2023 07:45:21 GMT
Message-ID: <20230825084500-0.1.e.uz3.0.q7lw6fvoei@corebizinsight.com>
Date:   Fri, 25 Aug 2023 07:45:21 GMT
From:   "Jakub Kovarik" <jakub.kovarik@corebizinsight.com>
To:     <ceph-devel@vger.kernel.org>
Subject: =?UTF-8?Q?Pros=C3=ADm_kontaktujte?=
X-Mailer: mail.corebizinsight.com
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_FMBLA_NEWDOM14,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        URIBL_CSS_A,URIBL_DBL_SPAM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  2.5 URIBL_DBL_SPAM Contains a spam URL listed in the Spamhaus DBL
        *      blocklist
        *      [URIs: corebizinsight.com]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [217.61.112.124 listed in zen.spamhaus.org]
        *  0.0 RCVD_IN_DNSWL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
        *      DNSWL was blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [217.61.112.124 listed in list.dnswl.org]
        *  0.1 URIBL_CSS_A Contains URL's A record listed in the Spamhaus CSS
        *      blocklist
        *      [URIs: corebizinsight.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  1.0 FROM_FMBLA_NEWDOM14 From domain was registered in last 7-14
        *      days
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dobr=C3=A9 r=C3=A1no,

Je mo=C5=BEn=C3=A9 s v=C3=A1mi nav=C3=A1zat spolupr=C3=A1ci?

R=C3=A1d si promluv=C3=ADm s osobou zab=C3=BDvaj=C3=ADc=C3=AD se prodejn=C3=
=AD =C4=8Dinnost=C3=AD.

Pom=C3=A1h=C3=A1me efektivn=C4=9B z=C3=ADsk=C3=A1vat nov=C3=A9 z=C3=A1kaz=
n=C3=ADky.

Nevahejte me kontaktovat.

V p=C5=99=C3=ADpad=C4=9B z=C3=A1jmu V=C3=A1s bude kontaktovat n=C3=A1=C5=A1=
 anglicky mluv=C3=ADc=C3=AD z=C3=A1stupce.


Pozdravy
Jakub Kovarik
