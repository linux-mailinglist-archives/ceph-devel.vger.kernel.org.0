Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9CFD1151A3
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2019 14:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfLFN4U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Dec 2019 08:56:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31274 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726250AbfLFN4T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Dec 2019 08:56:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575640578;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCmAV2OVqKDPaOuak54ooGID2p7VXD4uygHw0GkdqLM=;
        b=cepdL36gGOR4Y24LUJq0+9gGf3Je40nqo90lKqCtz6/4LAhngvP01z9JpAf2pKcwbNbl79
        Bi9lz3fZG/MtoboJqcRJbPPyVX9/qo9tmqnTUPDfPphPgja9Uk74fV0IIsaWAwDEzqXudh
        cjnA8GrRP6zvII0e39lRPJXbk+fURck=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-7CwINQe5NXGrOCo6HIAoew-1; Fri, 06 Dec 2019 08:56:15 -0500
Received: by mail-ed1-f72.google.com with SMTP id l6so4166462edc.18
        for <ceph-devel@vger.kernel.org>; Fri, 06 Dec 2019 05:56:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=dQarOUu+CZlDxOJEGVP0k7IhuSSlf/Q0SnLaICKKsJA=;
        b=YiAHFuiFhQ0FZqLM5mOPBsgA8CG3QlJ9O2NJ140aZzF3hoGyPohXDNd4Cq9mz7KIUa
         OR3nMPoioOyvTZAGFGu9pymnCPAmt8oZG34k034zXOUCWpCRVK0WfdmnW9Dig1winWq+
         RPGdlmFqPBeE4mEBx9XdStxtBy4GLSK8NlGGNZVKq95e+cS25/EVfA3ld3EQ8O7hVFCa
         Ljkrlwg14nqYnAGqluBBtVQs2nsfJBpfV3TlUzH72eyUvn572HUUeZDv6kj6xEF3XH0i
         ZeZpHf4Sr+Dzw0WivB4wyxoNTiAZtn9tA7/G+21g/oISxA5NuNdaSvsdLzZ0de9kqadq
         vdEw==
X-Gm-Message-State: APjAAAXe4ndauQ3sdBzRED+CiYeXCOQHXX5W7SGFrfAQAsuDU8De14qL
        0HEWw09vsObjlYz74LYw1UVkG53iCxCqxmpgIT6PP2Snr61v/Lar+hQxBdSyZ0cXaB61SwWk5xK
        oBAq2GPts2/HcMAjSYALDkcQex8jJCnMVf01xiQ==
X-Received: by 2002:a17:906:fcd2:: with SMTP id qx18mr14993975ejb.230.1575640573901;
        Fri, 06 Dec 2019 05:56:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwmmviRKNENrGV2VaKWn2ve1c/pGI+bKQCyyddHxcrpcUjouPxAdta8ZqyhPn5biWUtAdAUocp644XqY2TsVsY=
X-Received: by 2002:a17:906:fcd2:: with SMTP id qx18mr14993954ejb.230.1575640573650;
 Fri, 06 Dec 2019 05:56:13 -0800 (PST)
MIME-Version: 1.0
References: <CAOsMsV0WMsmPBcV35qZ3Ugup9n4N1n8fCSeZiuyoeWEyMgcdTA@mail.gmail.com>
In-Reply-To: <CAOsMsV0WMsmPBcV35qZ3Ugup9n4N1n8fCSeZiuyoeWEyMgcdTA@mail.gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Fri, 6 Dec 2019 08:56:02 -0500
Message-ID: <CA+aFP1DUO15TbwcEfKeXSnPonRj3ykmJRBBakNs2QOY0=JER4g@mail.gmail.com>
Subject: Re: About the optimization of rbd object map
To:     Li Wang <laurence.liwang@gmail.com>
Cc:     Sage Weil <sweil@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
X-MC-Unique: 7CwINQe5NXGrOCo6HIAoew-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 5, 2019 at 11:14 PM Li Wang <laurence.liwang@gmail.com> wrote:
>
> Hi Jason,
>   We found the synchronous process of object map, which, as a result,
> write two objects
> every write greatly slow down the first write performance of a newly
> created rbd by up to 10x,
> which is not acceptable in our scenario, so could we do some
> optimizations on it,
> for example, batch the map writes or lazy update the map, do we need
> maintain accurate
> synchronization between the map and the data objects? but after a
> glimpse of the librbd codes,
> it seems no transactional design for the two objects (map object and
> data object) write?

If you don't update the object-map before issuing the first write to
the associated object, you could crash and therefore the object-map's
state is worthless since you couldn't trust it to tell the truth. The
cost of object-map is supposed to be amortized over time so the first
writes on a new image will incur the performance hits, but future
writes do not.

The good news is that you are more than welcome to disable
object-map/fast-diff if the performance penalty is too great for your
application -- it's not a required feature of RBD.

>
> Cheers,
> Li Wang
>


--=20
Jason

