Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992693404C0
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Mar 2021 12:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCRLiS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Mar 2021 07:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbhCRLhs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 Mar 2021 07:37:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F626C06174A
        for <ceph-devel@vger.kernel.org>; Thu, 18 Mar 2021 04:37:48 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso2964715pjb.4
        for <ceph-devel@vger.kernel.org>; Thu, 18 Mar 2021 04:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Xa/OTIx3Y/cWLbBdo6jLDXf/uPBTJqYPXhW7/qoi9FY=;
        b=CCJMaQMrC+KFRpJwgXxo14ApvzFPlxQRbCnNFahAMM7LS+s/7AaoSns7odfTD32ggR
         PQK0CwgvzuEolqqNthw9A4fpC86pSRuWV/PJpWvaxFGAui5DHzICMwf99pUHKbH88kGJ
         skUsXO29dVURWkUHysW/qGaHroF9OpNxHMZ2Am4kVH2s+7CIAzu1BTR0w5PxJIC6/zlb
         rPdCTcSZ3xSPst2bqhmiJXHZBN/T5DlJctRBN/Q0QT1XO0AzWkHA8R+SJE/JbCyBnOSz
         7Ghu3udfwcIbAIc/nmpltD0E/iXiNnn7AtI0mJac2+7/2+RzbEb/1HCpJ3T/hKM3Q37z
         I/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Xa/OTIx3Y/cWLbBdo6jLDXf/uPBTJqYPXhW7/qoi9FY=;
        b=aIkOvajaDdpdJtb/0MRY37GISEtH/byYB5BXJKLJGMi7qu07mNNqUA24+ZqmH2HoXU
         NC8OsliszrBvm/a74pMCqIeiFjipRwp2I0NHKwV/hv5LTL8sZcPiosMBrMBQ/w2xjjeK
         QolvJUovsfeaOiZP0TciFUutKVIhIE7vBwCFKu+gbY3UHj276mJ27YwpD79C0+hVGyTs
         bnFyOoGHjsx/GBzI1bnusGgIx6ccV+wADvcrmLi781UlhDlBXM41JYm0O/GSkk1iAyJN
         bLw6lxM6rIlE5vj9dLc9xo/TSlooyp3BFoREOMfYCWpfpzW9mnuUFLlZFTs6QDJ0WNbT
         vGfg==
X-Gm-Message-State: AOAM530/oAq1NYo2hvZdKQFW81Yi+G3fZvejFyo0hETmSWOOTFbJsNn9
        /XL/VMNEQauXlbV3lpZG8IpUNag3dY40WlHJOCpzlFawTjajuw==
X-Google-Smtp-Source: ABdhPJx5sBwDmHPzCTJuHp9EOEMpRf5UYD+tEyeW+g9UqIxYzsHqBAoKYa/mQYm/jVknLJSs7Fl8MBYFjTmQ6Ong4bE=
X-Received: by 2002:a17:902:bb91:b029:e6:bc94:4899 with SMTP id
 m17-20020a170902bb91b02900e6bc944899mr9093980pls.25.1616067467847; Thu, 18
 Mar 2021 04:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAPy+zYWQbVojqLPdcM=Q7kEPx=ju6_efTd0-DSoryVSbiyhJLg@mail.gmail.com>
In-Reply-To: <CAPy+zYWQbVojqLPdcM=Q7kEPx=ju6_efTd0-DSoryVSbiyhJLg@mail.gmail.com>
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Thu, 18 Mar 2021 19:37:35 +0800
Message-ID: <CAPy+zYVhfT5CYFP5=8=C6FrzvvxbGEM_ouMPUkRqUf0Db0Lmhg@mail.gmail.com>
Subject: Re: rgw: Is rgw_sync_lease_period=120s set small?
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I have an osd ceph cluster, rgw instance often appears to be renewed
and not locked

WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8818=E6=
=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=887:35=E5=86=99=E9=81=93=EF=BC=9A
>
> In an rgw multi-site production environment, how many rgw instances
> will be started in a single zone? According to my test, multiple rgw
> instances will compete for the datalog leaselock, and it is very
> likely that the leaselock will not be renewed. Is the default
> rgw_sync_lease_period=3D120s a bit small?
