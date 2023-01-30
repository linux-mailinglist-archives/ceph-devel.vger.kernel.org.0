Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05969681948
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Jan 2023 19:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237900AbjA3Sfe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Jan 2023 13:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237393AbjA3Sfd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 Jan 2023 13:35:33 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98357170F;
        Mon, 30 Jan 2023 10:35:30 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id dr8so12888525ejc.12;
        Mon, 30 Jan 2023 10:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9FE8Tg/ETfLF2znBVGSneSNpDHtD4K+4dzhis/koiic=;
        b=TdmKB3xUWwABi5gYQNKjBDn+QIkfyNCfLMKldrUBcWh0xLgeMjLs3Qub+GOKGwMozm
         FUbJ1XZpC2jhGxFhyyhzN118RA97F6oSOXm3m1/Wk+FMjfUWolHE100s5kNNs+L38530
         uOMnspdpGVscA37fmr5QPdeoxhIyThNBJdmwhiF6nQnureuktWkd6Kjmwi65jygf0nHZ
         rIy2rkDK2Db/9GyNHpy3U5BFUA5hqu2EF0t9o15V7jSS6IE6idX4bXNtQazLjHQ6mKVg
         66TdcLQr33MVchRcfI9E3P1LjAwRTNx+NjLiDce4tI2AmTdZIRtd42lzwZYv312KXNeQ
         C0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9FE8Tg/ETfLF2znBVGSneSNpDHtD4K+4dzhis/koiic=;
        b=Ofl4uXiXhCZCIHhOX5LlX3U++GgUD/AfnBc4WI11c03JGtcdUB7DQsH6YI9t9EBTJC
         Z0v9OGWGYjNwT7uFPleulD683C6nDcWu9f6Y4DsoFXL73S5j2YhSJjAKh6oSTueKXEBk
         4gxyqJNeew8OVveDIo2p4efbtndy03iHM2o4AjoGzS0acrYqZc3f/yxp6OZVZWOM4ibS
         zksM5+LL01aS1+WinBGffu2RSeqljJEgrLoy50VK0/BO7YFSmUW0uBHHPjKcLG3FTd/s
         PZ12WsHVeTuFrhEqDocPNs5PBd2V15QyUcn9TCw6Xx5ugn+EtUhRxd9P2BwfONqK5cb5
         VJyw==
X-Gm-Message-State: AFqh2koVoejSB49Rt+fI7qlLud79mKaUDJLr0Ksc17fdVGghDQIfZc/a
        FEQt1S5uJ9kuuUCRrCqf2BRjGbVvUn2HAVObheI=
X-Google-Smtp-Source: AMrXdXvnrppwjWc2GYoaSQvqFwNiTQID4l0gmI8rLvQT5AS+GqW5c9yL3gsxiJUvTOWQUcAgkpnAGLzZ827Cy2iv9XQ=
X-Received: by 2002:a17:906:3658:b0:872:68a:a17e with SMTP id
 r24-20020a170906365800b00872068aa17emr7442256ejb.159.1675103729082; Mon, 30
 Jan 2023 10:35:29 -0800 (PST)
MIME-Version: 1.0
References: <20230130092157.1759539-2-hch@lst.de> <20230130092157.1759539-1-hch@lst.de>
 <3347557.1675074816@warthog.procyon.org.uk> <20230130103619.GA11874@lst.de>
In-Reply-To: <20230130103619.GA11874@lst.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 30 Jan 2023 19:35:17 +0100
Message-ID: <CAOi1vP_aU58YpiOkYgQy4a=VVnm64WeWH5pwYf+bc_C=COYY3g@mail.gmail.com>
Subject: Re: [PATCH 01/23] block: factor out a bvec_set_page helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 30, 2023 at 11:36 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Jan 30, 2023 at 10:33:36AM +0000, David Howells wrote:
> > Christoph Hellwig <hch@lst.de> wrote:
> >
> > > +static inline void bvec_set_page(struct bio_vec *bv, struct page *page,
> > > +           unsigned int len, unsigned int offset)
> >
> > Could you swap len and offset around?  It reads better offset first.  You move
> > offset into the page and then do something with len bytes.
>
> This matches bio_add_page and the order inside bio_vec itself.  willy
> wanted to switch it around for bio_add_folio but Jens didn't like it,
> so I'll stick to the current convention in this area as well.

This also matches sg_set_page() so sticking to the current convention
is definitely a good idea!

Thanks,

                Ilya
