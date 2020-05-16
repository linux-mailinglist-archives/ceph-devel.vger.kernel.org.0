Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA0D1D63E5
	for <lists+ceph-devel@lfdr.de>; Sat, 16 May 2020 22:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgEPUAD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 16 May 2020 16:00:03 -0400
Received: from sonic306-2.consmr.mail.bf2.yahoo.com ([74.6.132.41]:32769 "EHLO
        sonic306-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbgEPUAD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 16 May 2020 16:00:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589659202; bh=lMwnL/6WltFrTd0TmVnY+7WY/Sq+3khHK9hYAyAunB4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jB8+1fg3q4aMGhbAD7cL944bgwLXvNuCjiS3aFR8OYrzlno/5fPSu2Z73misYUH7QxRv1+vkzjwZznasXtEpXQ4+/667CzK/k4jHp3M+i2jmYrHLhmxl5V4yctH/LFjJE7v/xdi3M2bR6+iHaey9o7FzHBbMM0EM9Wz2CHYbcIunioHC8NWa4b2RERsI6xo6g2hSYsGEdxRoGXwMRdNfCNp5SmmPqFIYSSipCwp8CEl6aRiAa7GpHTeUSJ2DIA0hT6RozhLrBAY6K13mu6J7mVrFBdEOpt1xxwjwJj9YrExv89q4OXJDfdSCnbp0+9QYJ6skkw0/2M1AZXZessiyJg==
X-YMail-OSG: FT06_DcVM1k7Y1H857iM0jSmZwfCojs.amGKnqOhWP8rRCC6wTpUe5lyKvnDZ2C
 eUCE9S_if.OVyKOtEiifZ3dkp0Yaf7wA4b3EcU0PZZF2yFIc6bTx76KwNiXVBw3pR3cgAcOxhG75
 qbL.K.mGqEJaY06mLaIO4wvDjr486w_JDy.hhXp6i0NsdLYZFUIqwwEgJEpNqZ5aE0G9OEpHEwNi
 FsI02yX_IQaoWD7Dbq26RkhYmJv.oSQVxIvxJNPffQpyrd2fsVglOY.LyVZm9s8Zmquj5yhavQHx
 _XagzMQxionetAmGR6sCWf5.WNfq8wb0rDV5o6s4m1pBM_3Q6j2sW5S7duqIH0Nci0bFvNLO_KHh
 FV.6d_10LFv6TAPPG3J1G_G8vPsAtRfIW_ULAd1czzY6.aSVbmOCrDIf7STgL9kc8nVbYQhBUTIN
 nsefMkFWUsivz7K5O6EzWOvglTK4bqFJko_svH2qFyc5wGRnrocKP9pJ2xnv5Rxjc0WMd9LT.w5F
 zICYzAav9E52kezO.KMUAcaI5Zb5jA02Cv1NTtHn_DgErmv77Es5tAQ_8TaXnaaV82nu8hn_BSrb
 _BjoLbbKoKGJDIGCH88boWmSE6203_UVALc2B0Bd.7gMVnC25Y5kYrERHfKKKoB6j9LTiPFv3dxk
 tJxhOxcsqrUfRPVMVQcCZ.QKmpG.jSFYk0lI5STp3xVKKdhIImNTt7TEeyPLV3xtf4Jqczd_jvuY
 UQ6ddh9loDNepfmW7tKYNJ9XAE.VpIbfd_0cOfawjhluXxZR.XOTbJL7gUdTvDcTZ7iMnZQj1nAc
 PBB5Neu8u6h4WadwbkTnZwunQVxbkeb1SCO2W9eCSIw_j4nnkR4j8R_iua1aOI1JbiHS32FSGVef
 euy4y_bYZDZkwjwpfg7zfPQ8bZgr0hNDMTSFX7_W4ZWkwOvds._bG225h9XuOHJoB0GaficMR9_4
 7NTHLOVicZQ_gFSa.nX1aFIbcbQTaP1QaPokdsS8N6gR0rGPs54oNKmZPReb7slY2cwE8.kF42Ey
 cEuXaWGz4G4ufqtUXgFVUZXIqu4y.nFfZkC..Y0l7mho28UsVbNSJtgb78RmSty51sHHDwH_HyaH
 PdJD.sLTJjjchPGpMlFvlZFTZsbwXfZGHBdXZmS8UPlxId9ynvDCDNPzWulFmFJc.j5tBMRFRL9u
 OHXvSY2ct3lP3NtbdRx4FKqctwazsiqQ5M9HbfcFu0RL4wy3yvNQQczT1XcKdxvRm6jyE6fncFSc
 WiAouvtwCiuvm7aL.5Vhh92H6mB.ihFU2Xwja7Tbuynew.svbDFvrlrIp8Y..z65ViQNsUwi2dNh
 S_LQH
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Sat, 16 May 2020 20:00:02 +0000
Date:   Sat, 16 May 2020 20:00:01 +0000 (UTC)
From:   Rose Gordon <rosegordonor@gmail.com>
Reply-To: rosegordonor@gmail.com
Message-ID: <191588446.154429.1589659201443@mail.yahoo.com>
Subject: Greetings to you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <191588446.154429.1589659201443.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15960 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Greetings to you,
I hope that this letter finds you in the best of health and spirit. My name is Rose Gordan, Please I kindly request for your attention, I have a very important business to discuss with you privately and in a much matured manner but i will give the details upon receipt of your response,

Thank you in advance!

Yours sincerely,
Rose.
