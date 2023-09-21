Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB92D7A9A3B
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Sep 2023 20:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjIUShl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Sep 2023 14:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjIUShQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Sep 2023 14:37:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C8D2402C
        for <ceph-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:31:30 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-99c3c8adb27so153249266b.1
        for <ceph-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695317485; x=1695922285; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NwwU6GeRq3+G6S/WISshXAKEUxgM4c8MZP6v+rHJXXo=;
        b=UdtEcVfSPUYs1m6PerXDK094L+H23oFhWA8i+yr4VaybnSt5lNJR6T+fTOGHQbskwM
         Tsaz2XjlOrA2F3oOK9i846Z6yR6KuIUyNBlaHyC337kVzX955VIoN4pyDV81kuigzyzK
         sIKwAu3+7ZAMhgGxImY3kGE4SN7DxG3AIvDWfbCvrME/h4PBzgfVWvzBqMfFPa5fOkAL
         hRKTPk7kS1nxPLeEckIaBZlZr4DgeeQ3QKM3AfRveHADsOMwFk9utiD++6PKD7KHMVRi
         6ZSGoGIfQ9rsPNRlo8aJ0+i3CA1wDcHYFxDsx+0Bv28zWMdxd/sMqpmUJVigwdD/gmkv
         L4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695317485; x=1695922285;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NwwU6GeRq3+G6S/WISshXAKEUxgM4c8MZP6v+rHJXXo=;
        b=bNu0Bfz/DHFQjfUhwuGatvdn7KYXF2cPZyPmTKft86eiamHcwdoMah2bw5r36g1eUV
         elH4oR7cqA9drI3tiFuORtsOrVHxhkJLWUYesTQc9I70oXr+VZ37/a1Gq87YK16VnY6h
         59kL9f+6T81Iu3D0RNfRvuFtTau84gJuIyzxzKTXpsFfDcsaMkS97azbQm3sJOSltEgv
         LyVS8UYXv3CUINn/s4aJDACM8ivnhKkT5b3MypddeXPP02jWRoNIqr6IKktNRCap6HUM
         9VVcoSahiRyMbSzSeXmsBeId8buuesiN2vR97xypn+i7naJWYioPrmv9/cVw7FuLhgvu
         Wblg==
X-Gm-Message-State: AOJu0YzGB9ixHNrM4PZ0cx57lzYQ/VhrE/xoegbv/EWdEvFqWzEG76r/
        CALInc095eZ885v5xQl7D4go7tfdW4cy5Z2o4SK7K4qir18p8Q==
X-Google-Smtp-Source: AGHT+IFvU/g0W5/OmRO8WEKVmjY/jX+iOUxevnQM5El7yZDJyA+iaNYOuwwNcU0nXAysFlo6qRsHycoFvTguMYdCfBo=
X-Received: by 2002:adf:fccb:0:b0:319:74b5:b67d with SMTP id
 f11-20020adffccb000000b0031974b5b67dmr4683448wrs.66.1695296144508; Thu, 21
 Sep 2023 04:35:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:1e0b:b0:322:2c51:1e2 with HTTP; Thu, 21 Sep 2023
 04:35:43 -0700 (PDT)
Reply-To: cathydamian7@gmail.com
From:   Cathy Damian <ibnahmad46@gmail.com>
Date:   Thu, 21 Sep 2023 12:35:43 +0100
Message-ID: <CANSJc5pMPPfmw1pb+7YLPz-kQ2c-ZnHL+EpSvOA7uUHbi40B6Q@mail.gmail.com>
Subject: PLESAE READ!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Good day my beloved,

I believe this letter may come to you as a surprise. I came across
your email contact through a private search while in need of
assistance. I am writing this mail to you with heavy sorrow in my
heart. I have chosen to reach you through the internet because it
still remains the safest medium of communication.

I am Mrs.Cathy Damian, 65 years old,half Australian and half English.I
am currently hospitalized in a private hospital in Japan as a result
of lungs cancer. I was diagnosed of lungs cancer 4 years ago,
immediately after the death of my husband, who left me everything he
had. I'm with my laptop in a hospital where I have been undergoing
treatment for cancer of the lungs.

I have an inherited fund from my late husband in total sum of
Seventeen Million, Five Hundred Thousand Dollars (USD$17,500,000,00).
Now it's clear that I'm approaching the last-days of my life, I don't
think I need this money anymore. My doctor made me to understand that
I would not last for the period of one year due to Lungs cancer
problem.

This money is still with the foreign bank and the management wrote me
as the true owner to come forward to receive the money or rather issue
a letter of authorization to somebody to receive it on my behalf since
I can't come over because of my illness. Failure to act the bank may
get the fund confiscated for keeping it so long.

I decided to contact you if you are willing and interested to help me
withdraw this money from the foreign bank then use the funds for
Charity works in helping the less privileged. I want you to handle
these trust funds in good faith before anything happens to me. This is
not a stolen money and there are no dangers involved. It is 100% risk
free with full legal proof.

I want you to take 35% of the total money for your personal use while
65% of the money will go to charity work. I will appreciate your
utmost trust and confidentiality in this matter to accomplish my heart
desire, as I don't want anything that will jeopardize my last wish. I
am very sorry if you received this letter in your spam, Its due to
recent connection error here in the country.

Your beloved Sister,
Mrs. Cathy Damian.
