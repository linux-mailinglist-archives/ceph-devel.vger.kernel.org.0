Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450F0278435
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Sep 2020 11:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgIYJk1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Sep 2020 05:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbgIYJk0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Sep 2020 05:40:26 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEF0C0613CE
        for <ceph-devel@vger.kernel.org>; Fri, 25 Sep 2020 02:40:26 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id y9so1760893ilq.2
        for <ceph-devel@vger.kernel.org>; Fri, 25 Sep 2020 02:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tAYrhy1HXERHn4BgOnV52dJ/oDGS1VG73rZL7zEtL6E=;
        b=T9b5OPLqcA7Q3gHS64YfQYb7RwqE6uoL1hneUp7psHwUmZ7PcYtZohztZ8XUqwT/UB
         EtyKX/iUL74A70iGhgV8nPKAHJfx2Ymf78kNpHORTnUw93QmjAGH8WRMsXwauzTFnuLv
         rXiqu2NugF5VSi0dML87gJMt0MYhNvmoFXJAri68/a1cCr95lCY3g5fWfc57fkgoq7ad
         J4pxfYoq2e6FKiRTNT46TAD0UoPlN/DThM4XtBlJm2M15BGBbfyuufBFtPspT6HvvmKJ
         Hh7DatnMpg8fXN6TjVsXBY+Iu6E7GwxiaHLy+7KpnaEf5Moz8zo/FCpWktoUHrpozHVL
         g06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tAYrhy1HXERHn4BgOnV52dJ/oDGS1VG73rZL7zEtL6E=;
        b=FrBmuwHniZTWk0+GAaBUgmjSSIctO4yHt97QPEYiJDf8ulvOdAwe0NdzdlMPTi7c8m
         mKoLJfnnjanhiz9/vHrBx1VL9G2bFHs1MzkenjrKLGEvhGsu2P06cnpAyvobEtXLAS+6
         KhN+m3DvYYMUVvM9oMCrFui15hKPe4WCPYN83fJKEoAoiAyI9qsM+ZuLdagk3YP2i4hn
         poBsN3YCHfn+I1X9Xm1s6bcqdf6JWRcQHZN45zUtDqW2afenFOAcL36tqMOqlKrXDjjB
         MAgaliaQFvaRZecSo21DP3rdcso8iX+dzElB40CthhnsRkiucKDNth7QGV7/mhLkB5M6
         8dGQ==
X-Gm-Message-State: AOAM533JEgx+SUxOLUWK4xCeDcEW+GFFkEcRUEQoMer7ZGiSIMg7V0so
        iFi9x6/srloiPhHOXuUJM9SouTzfY1AEMppcfAM=
X-Google-Smtp-Source: ABdhPJzo2X231xx7+nD8O74iV4Ua03zORdRAY6LcAnuVn3LZ2mQsxuefeI3hmmH0AdAMy2o/Eyv4+BoZPCKl929oWsw=
X-Received: by 2002:a05:6e02:5cf:: with SMTP id l15mr2334784ils.281.1601026826001;
 Fri, 25 Sep 2020 02:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200925014806.GA1422079@jerryopenix>
In-Reply-To: <20200925014806.GA1422079@jerryopenix>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 25 Sep 2020 11:40:21 +0200
Message-ID: <CAOi1vP_pAZgiQYW=yJjLm6M000Q_iJWwqVYLOZxLhdTW=COzFw@mail.gmail.com>
Subject: Re: [PATCH] ceph: remove unused macro anywhere
To:     "Liu, Changcheng" <changcheng.liu@intel.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 25, 2020 at 3:55 AM Liu, Changcheng
<changcheng.liu@intel.com> wrote:
>
> CEPH_PORT_FIRST isn't used anywhere.
> non-monitors ports are in below range:
>   [CEPH_PORT_START, CEPH_PORT_LAST]
>
> Signed-off-by: Changcheng Liu <changcheng.liu@aliyun.com>
>
> diff --git a/include/linux/ceph/msgr.h b/include/linux/ceph/msgr.h
> index 9e50aede46c8..0e7888665492 100644
> --- a/include/linux/ceph/msgr.h
> +++ b/include/linux/ceph/msgr.h
> @@ -13,7 +13,6 @@
>   * range, simply for the benefit of tools like nmap or wireshark
>   * that would like to identify the protocol.
>   */
> -#define CEPH_PORT_FIRST  6789
>  #define CEPH_PORT_START  6800  /* non-monitors start here */
>  #define CEPH_PORT_LAST   6900
>
> --
> 2.17.1
>

Hi Changcheng,

This is sent from changcheng.liu@intel.com, but the Signed-off-by
line doesn't cover that address.  It is quite common for people to
own several addresses, but the Signed-off-by line has to match.

Could you please resend from the correct address / with the correct
Signed-off-by line?

Thanks,

                Ilya
