Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8948E2454CD
	for <lists+ceph-devel@lfdr.de>; Sun, 16 Aug 2020 00:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgHOWpx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 15 Aug 2020 18:45:53 -0400
Received: from sonic316-47.consmr.mail.bf2.yahoo.com ([74.6.130.221]:37860
        "EHLO sonic316-47.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728381AbgHOWpv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 15 Aug 2020 18:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597531549; bh=wQR2TNpnSC5+pl+9xCwBDdU8shZ+1jYIhLI8TGcKGS0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=FRx+jtkd3VGFhcEMD+Ka4Sp9i/eDX0ypghYqZF1szQ/C3fTpvF+ov0Hv8abTQ1N54ex8D1tibX5naanECWFXJB3dN/I97FqNFrTLKYAd+Gr9oGs7/4+HcW4Xd/wvVX0gITXRRjbDCbKdek56yO7GA9sHTFq1zFv5hV/ZE9uad8m9leMZaboxzYWlz21GhhXcUdqJ5KAnqlyDAt5j6oLqLpAErWivu04hyZi5uUw0dyRzLawaNHOLd6ZHyixs+1MsCgAcK3Wsk6vzTs3ZDLpHxk98bd5NBd4+0pfkZcYCOosRKo8Ew+Kk8Chf4DMVxo2Gnsd6z4dIMUGfaVeUKZNZjQ==
X-YMail-OSG: iYrsQSQVM1nlrXp7_D8iTqbMOnJ5jpfsmnGTxQSOCihEp3PE7kLTanVplNz69Ak
 ABAWBsr0Yt78NcNftdmwEkAHR6BReOegq1fLJRSEF7nU1TFS6D3.Xr6SZL5bf.31d4HP1pnTH.Ag
 jj0oY5IPULG225.0zwJrmamlI_AYVMHnIBOpBa3RnZEENrI_kknaHKYx45hCDdavdBdYh4YVOhnR
 LvIlCvacsMgYqZJ94PY962OMAL1.qIrM5fwX9GMlpbO5BUU9UaM6GGOFzr4goyTagB_UvAP0k0Qx
 2YLTsIG5OjCNS5T4xtVGLP7dEzQs3q87NAdqpzMzPd2VCR34aJ0_N7nRdSknz8v7RjBCIWdoECao
 UbaP7V9wQTzbR8wiEPLSoxDahEo9wtY4hQ8M22g2e05gFZTvLUYw6oFvp4jZrLPVrFLj8ZQ2hpZt
 gQh7kuPP9luir8HFqidt6Q21vBhsqO3s7xDuQTUjx1_Ddl.ikrc4kBJeBn4CAFprxZ4a1F0iQwR7
 FNCMQSv7q_HgK7_Ii_hqxuA3FxuDmA8JYC_0WtYpMAH0HvxvGKvIA7uunHInxTAxXujh0bycYWB9
 WWpbEy8LpMc5UC972SeQ5u1HX_6jVP0uiB1FcJ9BZfWDKcSkTav5RS4UtW3NF0SYeuU.Od9JcD9Z
 ceBq_5QGkhddBEKeZlEA2PD88lOf.CQqFSDiWqeoxIYOo_1YAJBHPt5yRNrtoV64mrOTbo0QlnAK
 QIj3mDaavxmAV__lUPXeprpNzw26gPHVEq6lgVGNgFt3NZnw_8QManbf4lKNoW4x0budDfHPQ0rm
 AHp.V3uLhT2lJFaTPhJVexKdHNAxmPbLkTCBA2rKVJY6K9vpx2wZUio1GGLeg8o0DaveAxF24dvP
 FpxUAC0Em_0oIH_B.ZUK2k1ttNgeZsQ62G5sCswQzsJ.hTEeu8lP8JIngdCZaPQKvnxxI07KKH7a
 PURxmvQR0li0RPj9ucqdfM6MDwJUpWFTHQhHyOzY4tFDhIzAcTKg0w.aUIzUzk72.89n6J3dC1ua
 cL8cjQSGGF2P9C.8ArXNZvVBZG.Hmc0aH_6LcdGkgLRRMvg0._O3.HWyuNOiP_GxzRY1wyDBbrsi
 1voLhqD96vCRNwonhrBw1pQ72jufpGsJQPyP7E9.SjmAWVGqtOT1zTugdxoa8RlsHPmDYJL4BZCk
 LEVhla5xkVo7GUD9JkvQtOo6eHgWUCKAFK6cpsYWjpkTRHjR7s09g.SPeorZ7KK9eeS4yQIN3v4L
 SNy0hYuBHk.7M9NvUbCCnVf39wv.stNX3UwBM2KzjJqq6IR8tfXv5v5rzC.KUnOo8yTQC71_bSD6
 y5zatprdMYSIoVK.2veMoOuBUpZ_USeo1raYMt_zhT99TT8wh.w_jqZHTbboh31Pdb70ETxbfEpP
 PhkUkNmFI
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Sat, 15 Aug 2020 22:45:49 +0000
Date:   Sat, 15 Aug 2020 22:43:49 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mua51@gvsao.in>
Reply-To: maurhinck2@gmail.com
Message-ID: <53360247.1921460.1597531429393@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <53360247.1921460.1597531429393.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck2@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
